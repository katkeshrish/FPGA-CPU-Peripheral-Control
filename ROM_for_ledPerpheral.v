`include "Led_peripheral.v"

module  Rom_for_ledPerpheral(
    output reg wr_en,
    output reg[7:0]data_address,
    output reg[7:0]write_data,
    input clk,rst

);

reg [7:0]rom[0:10];
reg [7:0]wr_ptr;
reg [7:0]pc;
wire [15:0]led;

Led_Peripheral l1(led,data_address,write_data,wr_en,clk,rst);


initial begin
rom[0]=8'h11;  //opcode
rom[1]=8'h12;  //opcode
rom[2]=8'h5;  //data write
rom[3]=8'h13;  //opcode
rom[4]=8'h5;  //data write
rom[5]=8'h14;  //opcode
rom[6]=8'h3;  //data write
rom[7]=8'h11; //once again opcode to check if what we did above is correct 
rom[8]=8'h12; //similarly to check waht we did is correct or not

end



reg [1:0]state;


always@(posedge clk or posedge rst)begin 
    if(rst)begin
        state<=0;
        wr_ptr<=0;
        data_address<=0;
        write_data<=0;
        wr_en<=0;
        //pc<=rom[wr_ptr];
    end else begin
        case(state)
            2'b00:
            begin
                pc<=rom[wr_ptr];   //FETCH
                state<=2'b01;
            end

            2'b01:
            begin
                case(pc)

                    8'h11: begin state<=10; wr_ptr<=wr_ptr+1; end
                    8'h12: begin state<=10; wr_ptr<=wr_ptr+1; end
                    8'h13: begin state<=10; wr_ptr<=wr_ptr+1; end
                    8'h14: begin state<=10; wr_ptr<=wr_ptr+1; end
                    default: begin state<=0; wr_ptr<=wr_ptr+1; end
                    

                endcase

                
            end

            2'b10:
            begin
                case(pc)
                    8'h11:
                    begin
                        state<=0; // i dont know what to do here
                    end

                    8'h12:
                    begin
                        data_address<=8'h1;
                        //wr_en<=0;
                        pc<=rom[wr_ptr];  //data fetch for write data for next clock cycle
                        state<=11;
                    end

                    8'h13:
                    begin
                        data_address<=8'h2;
                        pc<=rom[wr_ptr];   //data fetch for write data for next clock cycle
                        state<=11;
                    end

                    8'h14:
                    begin
                        data_address<=8'h3;
                        pc<=rom[wr_ptr];   //data fetch for write data for next clock cycle
                        state<=11;
                    end
                endcase
            
            end //
                2'b11: 
                begin
                    wr_en<=1;
                    write_data<=pc; //pc supposed to hold write data which was being fetched at erlier cycle
                    state<=0;
                end
            // end

        endcase

    end
end



endmodule


