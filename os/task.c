
// TODO: Clean this up



#define TASK_NAME_MAXLEN   31

struct tcb
{
    char name[TASK_NAME_MAXLEN + 1];
    uint32_t id;
    uint32_t priority;
    uint32_t effective_priority;

    // TODO: Do I need to save other CSRs as well?
    uint32_t program_counter;
    uint32_t registers[31];

    uint32_t stack_start;
    uint32_t stack_length;
    // ...
};


struct queue_entry
{
    bool active;
    struct tcb task;
    struct queue_entry* next;
};




// TODO: Running process
struct queue_entry* ready_queue;
struct queue_entry* disk_queue;



// enqueue, dequeue, reschedule, context_switch, etc.



void reschedule()
{

}



void context_switch(uint32_t* from_registers, uint32_t* to_registers);
