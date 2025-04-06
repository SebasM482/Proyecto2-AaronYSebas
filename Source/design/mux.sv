<<<<<<< HEAD
`timescale 1ns/1ps
// Este mux es controlado por el display controller, el cual indica si se deben mostrar las unidades, decenas o centenas.



module mux(
    input logic [2:0] a,    // Maquina de estados one-hot
    input logic [11:0] cdu,    // cdu[3:0] = unidades, cdu[7:4] = decenas, cdu[11:8] = centenas
    output logic [3:0] w    // Numero de 4 bits (salida)
);

    assign w = (a == 3'b001) ? cdu[3:0] :  // unidades
               (a == 3'b010) ? cdu[7:4] :  // decenas 
               (a == 3'b100) ? cdu[11:8] : // centenas
               4'b0000;

    
=======
`timescale 1ns/1ps
// Este mux es controlado por el display controller, el cual indica si se deben mostrar las unidades, decenas o centenas.



module mux(
    input logic [2:0] a,    // Maquina de estados one-hot
    input logic [11:0] cdu,    // cdu[3:0] = unidades, cdu[7:4] = decenas, cdu[11:8] = centenas
    output logic [3:0] w    // Numero de 4 bits (salida)
);

    assign w = (a == 3'b001) ? cdu[3:0] :  // unidades
               (a == 3'b010) ? cdu[7:4] :  // decenas 
               (a == 3'b100) ? cdu[11:8] : // centenas
               4'b0000;

    
>>>>>>> bdfb6c7c62bfd17886a7345be005be423d40c3bf
endmodule