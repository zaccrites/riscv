"""Generate a cmake module to create a target for a Verilog module.

"""

import os
import sys
import argparse
import subprocess

import jinja2
import colorama


# Sentinel object to indicate if output should to to stdout.
CMAKE_STDOUT = object()


TEMPLATE = r'''
# ============================================================================
# "V{{ verilog_module_name }}" library target
#   Verilated {{ verilog_module_path }}
# ============================================================================

# This file was auto-generated!
# DO NOT EDIT!


add_library(V{{ verilog_module_name }}
    {% for filename in generated_source_files -%}
    "{{ filename }}"
    {% endfor -%}
    "{{ verilator_include_dir }}/verilated.cpp"
)

target_include_directories(V{{ verilog_module_name }} PUBLIC
    "{{ verilator_output_dir }}"
    "{{ verilator_include_dir }}"
)

add_custom_command(
    OUTPUT
        {% for filename in outputs -%}
        "{{ filename }}"
        {% endfor %}
    COMMAND
        python
        "{{ __file__ }}"
        "{{ verilog_module_path }}"
        {% for include_path in verilog_include_paths -%}
        "-I{{ include_path }}"
        {% endfor -%}
        --verilator-output-dir "{{ verilator_output_dir }}"
        --verilator-include-dir "{{ verilator_include_dir }}"
        --cmake "{{ cmake_output_path }}"

    DEPENDS
        {% for filename in depends -%}
        "{{ filename }}"
        {% endfor %}
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    COMMENT "Running Verilator on \"{{ verilog_module_path }}\""
    VERBATIM
)

'''


class Depfile(object):

    def __init__(self, outputs, depends):
        self.outputs = outputs
        self.depends = depends

    @classmethod
    def parse(cls, args):
        depfiles = [
            os.path.join(args.verilator_output_dir, filename)
            for filename in os.listdir(args.verilator_output_dir) if
            os.path.splitext(filename)[1] == '.d'
        ]
        if not depfiles:
            return cls(set(), set())
        else:
            assert len(depfiles) == 1

        outputs = set()
        depends = set()
        with open(depfiles[0], 'r') as f:
            for line in f:
                line_outputs, line_depends = line.split(':')
                outputs.update(line_outputs.split())
                depends.update(line_depends.split())

        if args.cmake_module_path is not CMAKE_STDOUT:
            outputs.add(args.cmake_module_path)

        # Depend on this Python file so that Vmodules are regenerated
        # if the script that generates them (this one) changes.
        depends.add(__file__)

        # Remove the dependence on the Verilator binary as CMake
        # on MacOS thinks of it as a local file.
        # FUTURE: This should be a dependency, but an absolute one.
        depends.discard('verilator_bin')

        return cls(outputs, depends)

    def outputs_of_extension(self, extension):
        return [
            path for path in self.outputs
            if os.path.splitext(path)[1] == extension
        ]

    @property
    def oldest_output(self):
        timestamps = []
        for path in self.outputs:
            if os.path.exists(path):
                timestamps.append(os.path.getmtime(path))
        return min(timestamps)

    @property
    def newest_depend(self):
        timestamps = []
        for path in self.depends:
            if os.path.exists(path):
                timestamps.append(os.path.getmtime(path))
        return max(timestamps)

    @property
    def needs_regen(self):
        return self.newest_depend > self.oldest_output

    def __eq__(self, other):
        return (self.outputs, self.depends) == (other.outputs, other.depends)

    def __ne__(self, other):
        return not self.__eq__(other)


def run_verilator(args, include_paths):
    cmd = [
        'verilator_bin',
        '-Wall', '-cc', '--MMD',
        '--Mdir', args.verilator_output_dir,
        *[f'-I{path}' for path in include_paths],
        '-cc', args.verilog_module,
    ]
    p = subprocess.Popen(cmd, stderr=subprocess.PIPE)
    _, stderr = p.communicate()

    for line in stderr.splitlines():
        line = line.decode('utf-8')
        if line.startswith('%Error'):
            print(f'{colorama.Fore.RED}{line}{colorama.Style.RESET_ALL}', file=sys.stderr)
        elif line.startswith('%Warning'):
            print(f'{colorama.Fore.YELLOW}{line}{colorama.Style.RESET_ALL}', file=sys.stderr)
        else:
            print(line, file=sys.stderr)
    return p.returncode


def main():
    parser = argparse.ArgumentParser(description='Run Verilator and generate CMake module')
    parser.add_argument(
        'verilog_module',
        help='Path to top-level Verilog module',
    )
    parser.add_argument(
        '-I',
        dest='verilog_include_paths',
        action='append',
        help='Add a Verilog include path',
    )
    parser.add_argument(
        '--cmake',
        nargs='?',
        dest='cmake_module_path',
        const=CMAKE_STDOUT,
        help=('Generate CMake module at given path. If no path is given, '
              'output is written to stdout.'),
    )
    parser.add_argument(
        '--verilator-output-dir',
        help='Verilator output directory',
    )
    parser.add_argument(
        '--verilator-include-dir',
        default='/usr/share/verilator/include',
        help='Location of Verilator installation include directory',
    )
    args = parser.parse_args()

    try:
        os.makedirs(args.verilator_output_dir)
    except FileExistsError:
        pass

    previous_depfile = Depfile.parse(args)
    status_code = run_verilator(args, args.verilog_include_paths)
    if status_code:
        print(f'ERROR: Verilator exited with status {status_code}', file=sys.stderr)
        return status_code

    if args.cmake_module_path:
        depfile = Depfile.parse(args)

        # FUTURE: Regex against the file instead?
        module_name = os.path.splitext(os.path.basename(args.verilog_module))[0]

        environment = jinja2.Environment(undefined=jinja2.StrictUndefined)
        template = environment.from_string(TEMPLATE)
        content = template.render(
            verilog_module_name=module_name,
            verilog_module_path=args.verilog_module,
            verilog_include_paths=args.verilog_include_paths,
            verilator_output_dir=args.verilator_output_dir,
            verilator_include_dir=args.verilator_include_dir,
            generated_source_files=sorted(depfile.outputs_of_extension('.cpp')),
            generated_header_files=sorted(depfile.outputs_of_extension('.h')),
            outputs=sorted(depfile.outputs),
            depends=sorted(depfile.depends),
            cmake_output_path='' if args.cmake_module_path is CMAKE_STDOUT else args.cmake_module_path,
            __file__=__file__,
        )
        if args.cmake_module_path is CMAKE_STDOUT:
            print(content)
        else:
            # TODO: Reset timestamps on cpp and h files which haven't
            # changed to prevent them being needlessly rebuilt?

            cmake_dirty_criteria = [
                not os.path.exists(args.cmake_module_path),
                depfile != previous_depfile,
                depfile.needs_regen,
            ]
            if any(cmake_dirty_criteria):
                with open(args.cmake_module_path, 'w') as f:
                    f.write(content)
            else:
                print(f'-- {args.cmake_module_path} up-to-date.')



if __name__ == '__main__':
    sys.exit(main())
