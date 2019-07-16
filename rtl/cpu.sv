
module cpu(
    input i_Clock,
    input i_Reset);

    // Control?
    // Hazard detection?
    // Forwarding?


    logic w_IFID_NextPC;

    stage_IF IF(
        .i_Clock(i_Clock),
        .i_Reset(i_Reset),
        .i_Branch(TODO),
        .i_BranchAddress(TODO),
        .o_NextPC(w_IFID_NextPC),
    );







    stage_ID ID(
        .i_NextPC(w_IFID_NextPC),
    );


    // Signals passed through stages can be done here.
    // Only pass signals into a stage that are used in the stage.

    // Or can I use a SV interface to just bypass all of the signals?
    // They have to be registered somewhere.



    stage_EX EX(

    );


    stage_MEM MEM(

    );


    stage_WB WB(

    );

endmodule
