// DeBounce_v.v


//////////////////////// Button Debounceer ///////////////////////////////////////
//***********************************************************************
// FileName: DeBounce_v.v
// FPGA: MachXO2 7000HE
// IDE: Diamond 2.0.1 
//
// HDL IS PROVIDED "AS IS." DIGI-KEY EXPRESSLY DISCLAIMS ANY
// WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
// BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
// DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
// PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
// BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
// ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
// DIGI-KEY ALSO DISCLAIMS ANY LIABILITY FOR PATENT OR COPYRIGHT
// INFRINGEMENT.
//
// Version History
// Version 1.0 04/11/2013 Tony Storey
// Initial Public Release
// Small Footprint Button Debouncer

`timescale 1 ns / 1 ns
module  DeBounce 
	(
	input logic clk, n_reset, button_in,// inputs
	input logic [3:0] columnas,        // Entradas directas desde las filas del teclado
	output reg 	DB_out,					// output
	output logic [3:0] columna_presionada // Columna presionada en el teclado
	);
//// ---------------- internal constants --------------
	parameter N = 6 ;		// (2^ (21-1) ) / 27 MHz = 39 ms debounce time
////---------------- internal variables ---------------
	reg  [N-1 : 0]	q_reg;			// timing regs
	reg  [N-1 : 0]	q_next;
	reg DFF1, DFF2;					// input flip-flops
	wire q_add;						// control flags
	wire q_reset;
//// ----contenious assignment for counter control-------
	assign q_reset = (DFF1  ^ DFF2);		// xor input flip flops to look for level chage to reset counter
	assign  q_add = ~(q_reg[N-1]);			// add to counter when q_reg msb is equal to 0
	


	//-------- Logica de deteccion de columna -----------
	reg button_in_prev;
	reg DB_out_prev;
	reg flanco_detectado;

	always @(posedge clk or negedge n_reset) begin
		if (!n_reset) begin
			button_in_prev <= 0;
			DB_out_prev <= 0;
			flanco_detectado <= 0;
			columna_presionada <= 4'b0000;
		end else begin
			// Detectar flanco de subida de button_in
			if (button_in && !button_in_prev && !flanco_detectado) begin
				columna_presionada <= columnas;
				flanco_detectado <= 1;
			end

			// Detectar flanco negativo de DB_out
			if (DB_out_prev && !DB_out) begin
				columna_presionada <= 4'b0000;
				flanco_detectado <= 0;  // Habilitar nuevos flancos
			end

			// Guardar estados anteriores
			button_in_prev <= button_in;
			DB_out_prev <= DB_out;
		end
	end



// ---------------- Combo counter to manage q_next ---------------
	always @ (q_reset, q_add, q_reg)
		begin
			case( {q_reset , q_add})
				2'b00 :
						q_next <= q_reg;
				2'b01 :
						q_next <= q_reg + 1;
				default :
						q_next <= { N {1'b0} };
			endcase 	
		end
	
// ---------------- Flip-flop inputs and q_reg update ---------------
	always @ ( posedge clk )
		begin
			if(n_reset ==  1'b0)
				begin
					DFF1 <= 1'b0;
					DFF2 <= 1'b0;
					q_reg <= { N {1'b0} };
				end
			else
				begin
					DFF1 <= button_in;
					DFF2 <= DFF1;
					q_reg <= q_next;
				end
		end
	 
//// counter control
	always @ ( posedge clk )
		begin
			if(q_reg[N-1] == 1'b1)
					DB_out <= DFF2;
			else
					DB_out <= DB_out;
		end

	endmodule


