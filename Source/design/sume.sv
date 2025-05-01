module sume (
    input  logic clk, //Para encender
    input  logic n_reset, //Reseteo
    input  logic [3:0] sample, //Numero recibido
    output logic [11:0] cdu, //Suma de los numeros
    output logic [11:0] w1, //Esto es para la suma
    output logic [11:0] w2
);

typedef enum logic [2:0] {S0, S1, S2, S3, S4, S5, S6} statetype; //No se que hace esto, define variables?
statetype state, nextstate;

 //Esto es para la suma
logic reset = !n_reset; //Tecnisismo, para que los ff funcionen de manera sincronic

always_ff @(posedge clk or posedge reset) begin //Logica de output
    if (reset) begin //Esto reinicia la calcu
        cdu <= 12'd0; //Reinicio la suma
        w1 <= 12'd0; //Reinicio el w1
        w2 <= 12'd0; //reinicio el w2
        state <= S0;
    end 

    else begin
        state <= nextstate;
        case (state) //Esto determina el output para cada state
            S0: w1[11:8] <= sample;
            S1: w1[7:4]  <= sample; //En la 1 se cambian la centenas
            S2: w1[3:0]  <= sample; //En la 2 las decenas
            S3: w2[11:8] <= sample; //Unidades
            S4: w2[7:4]  <= sample; //Centenas para el segundo numero
            S5: w2[3:0]  <= sample; //Decenas para el segundo numero
            S6: cdu <= w1 + w2; //Unidades para el segundo numero
            default: ; //Defecto
        endcase
    end
end


always_comb begin //Transicion del profe
        case (state) //case
            S0: begin
                nextstate = S1;
            end
            S1: begin
                nextstate = S2;
            end
            S2: begin
                nextstate = S3;                  
            end
            S3: begin
                nextstate = S4;
            end
            S4: begin
                nextstate = S5;
            end
            S5: begin
                nextstate = S6;
            end 
            S6: begin
                nextstate = S0;
            end
            default: nextstate = S0;
        endcase
end
endmodule