module tb;
 import cv32e40p_pkg::*;
 logic valid;logic[31:0]ins,a,b;logic vo,ill,mul;logic[4:0]rd;alu_opcode_e op;logic[1:0]vm;logic[31:0]oa,ob;
 cv32e40p_issue2_decoder d(valid,ins,a,b,vo,ill,rd,op,mul,vm,oa,ob);
 function automatic [31:0] cvrr(input[5:0]fun,input bit mode8,input[4:0]rs2,rs1,rdx);
  cvrr={fun,1'b0,rs2,rs1,2'b00,mode8,rdx,7'b1111011};
 endfunction
 initial begin valid=1;a=32'h04030201;b=32'h01010101;
  ins=cvrr(6'b000000,1,2,1,3);#1;if(ill||!vo||op!=ALU_ADD||vm!=VEC_MODE8)$fatal(1,"cv.add.b decode");
  ins=cvrr(6'b001000,0,2,1,3);#1;if(ill||op!=ALU_MIN||vm!=VEC_MODE16)$fatal(1,"cv.min.h decode");
  ins=cvrr(6'b011010,1,2,1,3);#1;if(ill||op!=ALU_AND)$fatal(1,"cv.and.b decode");
  ins=cvrr(6'b001010,1,2,1,3);#1;if(ill||op!=ALU_MINU)$fatal(1,"cv.minu.b decode");
  ins=cvrr(6'b001101,0,2,1,3);#1;if(ill||op!=ALU_GTU)$fatal(1,"cv.cmpgtu.h decode");
  ins=cvrr(6'b111111,1,2,1,3);#1;if(!ill||vo)$fatal(1,"unsupported accepted");
  ins=cvrr(6'b000000,1,2,1,3);ins[14]=1'b1;#1;if(!ill)$fatal(1,"scalar replicate must stay Issue1");
  $display("PASS official Xcv Issue2 decode");$finish;
 end
endmodule
