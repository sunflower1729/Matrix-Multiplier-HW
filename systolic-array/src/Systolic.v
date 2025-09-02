`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/18 16:34:32
// Design Name: 
// Module Name: Systolic
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
// weight stationary, reverse order, tiling
//////////////////////////////////////////////////////////////////////////////////


module Systolic(
    input clk, rst
    );
    
    //Weight & Act
    reg [15:0] Weight_0;
    reg [15:0] Weight_1;
    reg [15:0] Weight_2;
    reg [15:0] Weight_3;
    reg WR_EN;
    
    reg [15:0] Act_0;
    reg [15:0] Act_1;
    reg [15:0] Act_2;
    reg [15:0] Act_3;
    
    wire [31:0] PSUM_0;
    wire [31:0] PSUM_1;
    wire [31:0] PSUM_2;
    wire [31:0] PSUM_3;
    
    //PE wire ACT, PSUM, WEI
    wire [15:0] M_ACT [0:11];
    wire [31:0] M_PSUM [0:11];
    wire [31:0] M_WEI [0:11];
    
    //PE wire Weight Enable
    reg [3:0] M_WR_EN;
    reg M_WR_EN_0;
    reg M_WR_EN_1;
    reg M_WR_EN_2;
    reg M_WR_EN_3;
    
    //MEM ACT, WEIGHT & PSUM
    reg [15:0] ACT_MEM [0:15][0:15];
    reg [15:0] WEI_MEM [0:15][0:15];
    
    reg [31:0] PSUM_MEM [0:15][0:15];
    
    //Memory 
    integer ACT_col, ACT_row, Wei_col, Wei_row;
    //for PSUM_MEM INIT
    integer z,x;
    

    always@(posedge clk)begin
          if(rst)begin
            ACT_col = 12;
            ACT_row = 16;
            Wei_col = 4;
            Wei_row = 9; 
            //Input WEI, ACT value
            //Weight         
            WEI_MEM[0][0]  = 16'd1;
            WEI_MEM[0][1]  = 16'd1;
            WEI_MEM[0][2]  = 16'd1;
            WEI_MEM[0][3]  = 16'd1;
                                  
            WEI_MEM[1][0]  = 16'd4;
            WEI_MEM[1][1]  = 16'd0;
            WEI_MEM[1][2]  = 16'd0;
            WEI_MEM[1][3]  = 16'd1;
                                  
            WEI_MEM[2][0]  = 16'd7;
            WEI_MEM[2][1]  = 16'd1;
            WEI_MEM[2][2]  = 16'd1;
            WEI_MEM[2][3]  = 16'd2;
                                  
            WEI_MEM[3][0]  = 16'd2;
            WEI_MEM[3][1]  = 16'd0;
            WEI_MEM[3][2]  = 16'd0;
            WEI_MEM[3][3]  = 16'd2;
                                  
            WEI_MEM[4][0]  = 16'd5;
            WEI_MEM[4][1]  = 16'd0;
            WEI_MEM[4][2]  = 16'd1;
            WEI_MEM[4][3]  = 16'd3;
                                  
            WEI_MEM[5][0]  = 16'd8;
            WEI_MEM[5][1]  = 16'd1;
            WEI_MEM[5][2]  = 16'd0;
            WEI_MEM[5][3]  = 16'd0;
                                  
            WEI_MEM[6][0]  = 16'd3;
            WEI_MEM[6][1]  = 16'd0;
            WEI_MEM[6][2]  = 16'd0;
            WEI_MEM[6][3]  = 16'd5;
                                  
            WEI_MEM[7][0]  = 16'd6;
            WEI_MEM[7][1]  = 16'd1;
            WEI_MEM[7][2]  = 16'd1;
            WEI_MEM[7][3]  = 16'd0;
                                  
            WEI_MEM[8][0]  = 16'd9;
            WEI_MEM[8][1]  = 16'd1;
            WEI_MEM[8][2]  = 16'd1;
            WEI_MEM[8][3]  = 16'd7;
                                  
            WEI_MEM[9][0]  = 16'd0;
            WEI_MEM[9][1]  = 16'd0;
            WEI_MEM[9][2]  = 16'd0;
            WEI_MEM[9][3]  = 16'd0;
                                  
            WEI_MEM[10][0]  = 16'd0;
            WEI_MEM[10][1]  = 16'd0;
            WEI_MEM[10][2]  = 16'd0;
            WEI_MEM[10][3]  = 16'd0;
                                  
            WEI_MEM[11][0]  = 16'd0;
            WEI_MEM[11][1]  = 16'd0;
            WEI_MEM[11][2]  = 16'd0;
            WEI_MEM[11][3]  = 16'd0;
            
            
            //ACT 
            ACT_MEM[0][0]  = 1;
            ACT_MEM[0][1]  = 2;
            ACT_MEM[0][2]  = 3;
            ACT_MEM[0][3]  = 7;
            ACT_MEM[0][4]  = 8;
            ACT_MEM[0][5]  = 9;
            ACT_MEM[0][6]  = 13;
            ACT_MEM[0][7]  = 14;
            ACT_MEM[0][8]  = 15;
            ACT_MEM[0][9]  = 0;
            ACT_MEM[0][10] = 0;
            ACT_MEM[0][11] = 0;
           
            //ACT
            ACT_MEM[1][0]  = 2;
            ACT_MEM[1][1]  = 3;
            ACT_MEM[1][2]  = 4;
            ACT_MEM[1][3]  = 8;
            ACT_MEM[1][4]  = 9;
            ACT_MEM[1][5]  = 10;
            ACT_MEM[1][6]  = 14;
            ACT_MEM[1][7]  = 15;
            ACT_MEM[1][8]  = 16;
            ACT_MEM[1][9]  = 0;
            ACT_MEM[1][10] = 0;
            ACT_MEM[1][11] = 0;
           
            //ACT
            ACT_MEM[2][0]  = 3;
            ACT_MEM[2][1]  = 4;
            ACT_MEM[2][2]  = 5;
            ACT_MEM[2][3]  = 9;
            ACT_MEM[2][4]  = 10;
            ACT_MEM[2][5]  = 11;
            ACT_MEM[2][6]  = 15;
            ACT_MEM[2][7]  = 16;
            ACT_MEM[2][8]  = 17;
            ACT_MEM[2][9]  = 0;
            ACT_MEM[2][10] = 0;
            ACT_MEM[2][11] = 0;
            
            //ACT
            ACT_MEM[3][0]  = 4;
            ACT_MEM[3][1]  = 5;
            ACT_MEM[3][2]  = 6;
            ACT_MEM[3][3]  = 10;
            ACT_MEM[3][4]  = 11;
            ACT_MEM[3][5]  = 12;
            ACT_MEM[3][6]  = 16;
            ACT_MEM[3][7]  = 17;
            ACT_MEM[3][8]  = 18;
            ACT_MEM[3][9]  = 0;
            ACT_MEM[3][10] = 0;
            ACT_MEM[3][11] = 0;
            
            //ACT
            ACT_MEM[4][0]  = 7;
            ACT_MEM[4][1]  = 8;
            ACT_MEM[4][2]  = 9;
            ACT_MEM[4][3]  = 13;
            ACT_MEM[4][4]  = 14;
            ACT_MEM[4][5]  = 15;
            ACT_MEM[4][6]  = 19;
            ACT_MEM[4][7]  = 20;
            ACT_MEM[4][8]  = 21;
            ACT_MEM[4][9]  = 0;
            ACT_MEM[4][10] = 0;
            ACT_MEM[4][11] = 0;
            
            //ACT
            ACT_MEM[5][0]  = 8;
            ACT_MEM[5][1]  = 9;
            ACT_MEM[5][2]  = 10;
            ACT_MEM[5][3]  = 14;
            ACT_MEM[5][4]  = 15;
            ACT_MEM[5][5]  = 16;
            ACT_MEM[5][6]  = 20;
            ACT_MEM[5][7]  = 21;
            ACT_MEM[5][8]  = 22;
            ACT_MEM[5][9]  = 0;
            ACT_MEM[5][10] = 0;
            ACT_MEM[5][11] = 0;
            
            //ACT
            ACT_MEM[6][0]  = 9;
            ACT_MEM[6][1]  = 10;
            ACT_MEM[6][2]  = 11;
            ACT_MEM[6][3]  = 15;
            ACT_MEM[6][4]  = 16;
            ACT_MEM[6][5]  = 17;
            ACT_MEM[6][6]  = 21;
            ACT_MEM[6][7]  = 22;
            ACT_MEM[6][8]  = 23;
            ACT_MEM[6][9]  = 0;
            ACT_MEM[6][10] = 0;
            ACT_MEM[6][11] = 0;
            
            //ACT
            ACT_MEM[7][0]  = 10;
            ACT_MEM[7][1]  = 11;
            ACT_MEM[7][2]  = 12;
            ACT_MEM[7][3]  = 16;
            ACT_MEM[7][4]  = 17;
            ACT_MEM[7][5]  = 18;
            ACT_MEM[7][6]  = 22;
            ACT_MEM[7][7]  = 23;
            ACT_MEM[7][8]  = 24;
            ACT_MEM[7][9]  = 0;
            ACT_MEM[7][10] = 0;
            ACT_MEM[7][11] = 0;
            
            //ACT
            ACT_MEM[8][0]  = 13;
            ACT_MEM[8][1]  = 14;
            ACT_MEM[8][2]  = 15;
            ACT_MEM[8][3]  = 19;
            ACT_MEM[8][4]  = 20;
            ACT_MEM[8][5]  = 21;
            ACT_MEM[8][6]  = 25;
            ACT_MEM[8][7]  = 26;
            ACT_MEM[8][8]  = 27;
            ACT_MEM[8][9]  = 0;
            ACT_MEM[8][10] = 0;
            ACT_MEM[8][11] = 0;
            
            //ACT
            ACT_MEM[9][0]  = 14; 
            ACT_MEM[9][1]  = 15;
            ACT_MEM[9][2]  = 16;
            ACT_MEM[9][3]  = 20;
            ACT_MEM[9][4]  = 21;
            ACT_MEM[9][5]  = 22;
            ACT_MEM[9][6]  = 26;
            ACT_MEM[9][7]  = 27;
            ACT_MEM[9][8]  = 28;
            ACT_MEM[9][9]  = 0;
            ACT_MEM[9][10] = 0;
            ACT_MEM[9][11] = 0;
            
            //ACT
            ACT_MEM[10][0]  = 15;
            ACT_MEM[10][1]  = 16;
            ACT_MEM[10][2]  = 17;
            ACT_MEM[10][3]  = 21;
            ACT_MEM[10][4]  = 22;
            ACT_MEM[10][5]  = 23;
            ACT_MEM[10][6]  = 27;
            ACT_MEM[10][7]  = 28;
            ACT_MEM[10][8]  = 29;
            ACT_MEM[10][9]  = 0;
            ACT_MEM[10][10] = 0;
            ACT_MEM[10][11] = 0;
            
            //ACT
            ACT_MEM[11][0]  = 16;
            ACT_MEM[11][1]  = 17;
            ACT_MEM[11][2]  = 18;
            ACT_MEM[11][3]  = 22;
            ACT_MEM[11][4]  = 23;
            ACT_MEM[11][5]  = 24;
            ACT_MEM[11][6]  = 28;
            ACT_MEM[11][7]  = 29;
            ACT_MEM[11][8]  = 30;
            ACT_MEM[11][9]  = 0;
            ACT_MEM[11][10] = 0;
            ACT_MEM[11][11] = 0;
            
            //ACT
            ACT_MEM[12][0]  = 19;
            ACT_MEM[12][1]  = 20;
            ACT_MEM[12][2]  = 21;
            ACT_MEM[12][3]  = 25;
            ACT_MEM[12][4]  = 26;
            ACT_MEM[12][5]  = 27;
            ACT_MEM[12][6]  = 31;
            ACT_MEM[12][7]  = 32;
            ACT_MEM[12][8]  = 33;
            ACT_MEM[12][9]  = 0;
            ACT_MEM[12][10] = 0;
            ACT_MEM[12][11] = 0;
            
            //ACT
            ACT_MEM[13][0]  = 20;
            ACT_MEM[13][1]  = 21;
            ACT_MEM[13][2]  = 22;
            ACT_MEM[13][3]  = 26;
            ACT_MEM[13][4]  = 27;
            ACT_MEM[13][5]  = 28;
            ACT_MEM[13][6]  = 32;
            ACT_MEM[13][7]  = 33;
            ACT_MEM[13][8]  = 34;
            ACT_MEM[13][9]  = 0;
            ACT_MEM[13][10] = 0;
            ACT_MEM[13][11] = 0;
            
            //ACT
            ACT_MEM[14][0]  = 21;
            ACT_MEM[14][1]  = 22;
            ACT_MEM[14][2]  = 23;
            ACT_MEM[14][3]  = 27;
            ACT_MEM[14][4]  = 28;
            ACT_MEM[14][5]  = 29;
            ACT_MEM[14][6]  = 33;
            ACT_MEM[14][7]  = 34;
            ACT_MEM[14][8]  = 35;
            ACT_MEM[14][9]  = 0;
            ACT_MEM[14][10] = 0;
            ACT_MEM[14][11] = 0;
            
            //ACT
            ACT_MEM[15][0]  = 22;
            ACT_MEM[15][1]  = 23;
            ACT_MEM[15][2]  = 24;
            ACT_MEM[15][3]  = 28;
            ACT_MEM[15][4]  = 29;
            ACT_MEM[15][5]  = 30;
            ACT_MEM[15][6]  = 34;
            ACT_MEM[15][7]  = 35;
            ACT_MEM[15][8]  = 36;
            ACT_MEM[15][9]  = 0;
            ACT_MEM[15][10] = 0;
            ACT_MEM[15][11] = 0;
            
            for(z=0; z<16; z=z+1)begin
                for(x=0; x<16; x=x+1)begin
                    PSUM_MEM[z][x] = 0;
                end
            end
        end
    end
    
    
    //State
    reg [3:0] state;
    //for PSUM state
    reg [5:0] state2;
    //for Weight State;
    reg [5:0] state3;
    
    localparam  INIT    =   'd0,
                ACT_STATE_0   =   'd1,
                ACT_STATE_1   =   'd2,
                ACT_STATE_2   =   'd3,
                ACT_STATE_3   =   'd4,
                ACT_STATE_4   =   'd5,
                ACT_STATE_5   =   'd6,
                ACT_STATE_6   =   'd7,
                ACT_STATE_7   =   'd8,
                END           =   'd9;
                
    localparam  PSUM_STATE_0    =   'd10,
                PSUM_STATE_1    =   'd11,
                PSUM_STATE_2    =   'd12,
                PSUM_STATE_3    =   'd13,
                PSUM_STATE_4    =   'd14,
                PSUM_STATE_5    =   'd15,
                PSUM_STATE_6    =   'd16;
                
    localparam  WEIGHT_STATE_0    =   'd20,
                WEIGHT_STATE_1    =   'd21;
    
    //for flag Weight Assign
    reg flag_WEI;
    
    //Systolic Array Weight Enable
    always@(posedge clk)begin
        if(rst)begin
            M_WR_EN = 4'b0000;
            M_WR_EN_0 = 1'b0;
            M_WR_EN_1 = 1'b0;
            M_WR_EN_2 = 1'b0;
            M_WR_EN_3 = 1'b0;
        end
        else begin
            if(WR_EN)begin
                M_WR_EN = 4'b0001;
                flag_WEI = 1;
            end
            case(M_WR_EN)
             4'b0000 : begin M_WR_EN_0 = 1'b0; flag_WEI = 0; end
             4'b0001 : begin M_WR_EN = 4'b0010; M_WR_EN_3 = 1'b1; M_WR_EN_0 = 1'b0;end
             4'b0010 : begin M_WR_EN = 4'b0011; M_WR_EN_2 = 1'b1; M_WR_EN_3 = 1'b0;end
             4'b0011 : begin M_WR_EN = 4'b0100; M_WR_EN_1 = 1'b1; M_WR_EN_2 = 1'b0;end
             4'b0100 : begin M_WR_EN = 4'b0000; M_WR_EN_0 = 1'b1; M_WR_EN_1 = 1'b0;end
            endcase
        end
    end
    
    //Systolic Array Weight stationary & ACT
    integer i; //Weight column
    integer j; //Weight row
    integer k; //Act column
    integer l; //Acr row
    
    integer j_2; //For Weight column Assign 
    
    integer m; //PSUM column
    integer n; //PSUM row
    
    reg [3:0] cnt;
    reg [3:0] cnt2; //for PSUM start
    reg [3:0] cnt3; //for Acr row repeat count
    
    reg [5:0] num [0:3];
    reg flag; //for Continue Array calculation
    reg PSUM_flag; //for PSUM row + 4
    
    always@(posedge clk) begin
        if(rst)begin
            i = 0; 
            j = 0; 
            k = 0; 
            l = 0;
            m = 0;
            n = 0;
            cnt = 0;
            cnt2 = 0; //for PSUM start
            cnt3 = 0;
            WR_EN = 0;
            state = 0;
            flag = 0;
            PSUM_flag = 0;
            j_2 = 3;
        end
        else begin
            //Weight & ACT Assign
            case(state)
                INIT: begin
                    Weight_0 <= WEI_MEM[j_2 - j][i];
                    Weight_1 <= WEI_MEM[j_2 - j][i+1];
                    Weight_2 <= WEI_MEM[j_2 - j][i+2];
                    Weight_3 <= WEI_MEM[j_2 - j][i+3];
                    j <= j + 1; //J + Weight cloumn num
                    cnt <= cnt + 1;
                    if(cnt == 3) begin
                        state <= ACT_STATE_0;
                        WR_EN <= 1;
                    end
                end
                ACT_STATE_0: begin
                    WR_EN <= 0;
                    Act_0 <= ACT_MEM[l][k];
                    Act_1 <= 0;
                    Act_2 <= 0;
                    Act_3 <= 0;
                    state <= ACT_STATE_1;
                end
                ACT_STATE_1 : begin
                    Act_0 <= ACT_MEM[l+1][k];
                    Act_1 <= ACT_MEM[l][k+1];
                    Act_2 <= 0;
                    Act_3 <= 0;
                    state <= ACT_STATE_2;
                end
                ACT_STATE_2 : begin
                    Act_0 <= ACT_MEM[l+2][k];
                    Act_1 <= ACT_MEM[l+1][k+1];
                    Act_2 <= ACT_MEM[l][k+2];
                    Act_3 <= 0;
                    state <= ACT_STATE_3;
                end
                ACT_STATE_3 : begin
                    Act_0 <= ACT_MEM[l+3][k];
                    Act_1 <= ACT_MEM[l+2][k+1];
                    Act_2 <= ACT_MEM[l+1][k+2];
                    Act_3 <= ACT_MEM[l][k+3];
                    if(l + 4 < ACT_row)
                        l = l + 1;
                    else begin
                        state <= ACT_STATE_4;
                        //for Weight assignn
                        // 0-> next row
                        // 1-> next column
                        if(j_2 < Wei_row - 1) begin
                            j_2 <= j_2 + 4;
                            j <= 0;
                            cnt <= 0;
                            state3 <= WEIGHT_STATE_0;
                            flag = 1;
                        end
                        else if(i + 4 < Wei_col) begin
                            j_2 <= 3;
                            j <= 0;
                            i <= i + 4;
                            cnt <= 0;
                            if(i < Wei_col)begin
                                state3 <= WEIGHT_STATE_1;
                                flag = 1;
                            end
                            else
                                flag = 0;
                        end
                    end
                    cnt2 = cnt2 + 1;
                    cnt3 = l;
                    if(cnt2 == 2)begin
                        m <= l - cnt3;
                        state2 <= PSUM_STATE_0;
                    end
                end
                ACT_STATE_4 : begin
                    Act_0 <= 0;
                    Act_1 <= ACT_MEM[l+3][k+1];
                    Act_2 <= ACT_MEM[l+2][k+2];
                    Act_3 <= ACT_MEM[l+1][k+3];
                    if(cnt2 == 1)begin
                        m <= l - cnt3;
                        state2 <= PSUM_STATE_0;
                    end
                    state <= ACT_STATE_5;
                    
                end
                ACT_STATE_5 : begin
                    cnt2 = 0;
                    Act_0 <= 0;
                    Act_1 <= 0;
                    Act_2 <= ACT_MEM[l+3][k+2];
                    Act_3 <= ACT_MEM[l+2][k+3];
                    state <= ACT_STATE_6;
                end
                ACT_STATE_6 : begin
                    Act_0 <= 0;
                    Act_1 <= 0;
                    Act_2 <= 0;
                    Act_3 <= ACT_MEM[l+3][k+3];
                    state <= ACT_STATE_7;
                end
                ACT_STATE_7 : begin
                    Act_0 <= 0;
                    Act_1 <= 0;
                    Act_2 <= 0;
                    Act_3 <= 0;
                    state <= END;
                end
                
            endcase
            
            //PSUM Load
            case(state2)
                PSUM_STATE_0 : begin
                    m <= l - cnt3;
                    if(PSUM_flag)begin
                        n = n + 4;
                        PSUM_flag = 0;
                    end
                    PSUM_MEM[m][n] = PSUM_MEM[m][n] + PSUM_0;
                    state2 <= PSUM_STATE_1;
                end
                PSUM_STATE_1 : begin
                    PSUM_MEM[m+1][n] = PSUM_MEM[m+1][n] + PSUM_0;
                    PSUM_MEM[m][n+1] = PSUM_MEM[m][n+1] + PSUM_1;
                    state2 <= PSUM_STATE_2;             
                end
                PSUM_STATE_2 : begin
                    PSUM_MEM[m+2][n]   = PSUM_MEM[m+2][n]   + PSUM_0;
                    PSUM_MEM[m+1][n+1] = PSUM_MEM[m+1][n+1] + PSUM_1;
                    PSUM_MEM[m][n+2]   = PSUM_MEM[m][n+2]   + PSUM_2;
                    state2 <= PSUM_STATE_3;
                end
                PSUM_STATE_3 : begin
                    PSUM_MEM[m+3][n]   = PSUM_MEM[m+3][n]   + PSUM_0;
                    PSUM_MEM[m+2][n+1] = PSUM_MEM[m+2][n+1] + PSUM_1;
                    PSUM_MEM[m+1][n+2] = PSUM_MEM[m+1][n+2] + PSUM_2;
                    PSUM_MEM[m][n+3]   = PSUM_MEM[m][n+3]   + PSUM_3;
                    if(m != cnt3)
                        m = m + 1;
                    else
                        state2 <= PSUM_STATE_4; 
                end
                PSUM_STATE_4 : begin
                    PSUM_MEM[m+3][n+1] = PSUM_MEM[m+3][n+1] + PSUM_1;
                    PSUM_MEM[m+2][n+2] = PSUM_MEM[m+2][n+2] + PSUM_2;
                    PSUM_MEM[m+1][n+3] = PSUM_MEM[m+1][n+3] + PSUM_3;
                    state2 <= PSUM_STATE_5; 
                end
                PSUM_STATE_5 : begin
                    PSUM_MEM[m+3][n+2] = PSUM_MEM[m+3][n+2] + PSUM_2;
                    PSUM_MEM[m+2][n+3] = PSUM_MEM[m+2][n+3] + PSUM_3;
                    state2 <= PSUM_STATE_6;
                end
                PSUM_STATE_6 : begin
                    PSUM_MEM[m+3][n+3] = PSUM_MEM[m+3][n+3] + PSUM_3;
                    state2 <= END;
                end
            endcase
            
            //Weight Assign
            case(state3)
                WEIGHT_STATE_0: begin
                    Weight_0 <= WEI_MEM[j_2 - j][i];
                    Weight_1 <= WEI_MEM[j_2 - j][i+1];
                    Weight_2 <= WEI_MEM[j_2 - j][i+2];
                    Weight_3 <= WEI_MEM[j_2 - j][i+3];
                    j <= j + 1; //J + Weight cloumn num
                    cnt <= cnt + 1;
                    if(cnt == 3) begin
                        //act
                        k <= k + 4;
                        l <= 0;
                        if(flag)begin
                            state <= ACT_STATE_0;
                            flag = 0;
                        end
                        state3 <= INIT;
                        WR_EN <= 1;
                    end
                end
                WEIGHT_STATE_1: begin
                    PSUM_flag = 1;
                    Weight_0 <= WEI_MEM[j_2 - j][i];
                    Weight_1 <= WEI_MEM[j_2 - j][i+1];
                    Weight_2 <= WEI_MEM[j_2 - j][i+2];
                    Weight_3 <= WEI_MEM[j_2 - j][i+3];
                    j <= j + 1; //J + Weight cloumn num
                    cnt <= cnt + 1;
                    if(cnt == 3) begin
                        //act
                        k = 0;
                        l = 0;
                        if(flag)begin
                            state <= ACT_STATE_0;
                            flag = 0;
                        end
                        state3 <= INIT;
                        WR_EN <= 1;
                    end
                end
            endcase
        end
    end
    
    wire [31:0] Zero;
    assign Zero = 32'b0;
    
    PE PE1(.clk(clk), .rst(rst),  .WR_EN(M_WR_EN_3), .PSUM(Zero), .Weight(Weight_0), .out_Weight(M_WEI[0]), .ACT(Act_0), .flag(flag_WEI), .out_ACT(M_ACT[0]), .out_PSUM(M_PSUM[0]));
    PE PE2(.clk(clk), .rst(rst),  .WR_EN(M_WR_EN_2), .PSUM(M_PSUM[0]), .Weight(M_WEI[0]), .out_Weight(M_WEI[1]), .ACT(Act_1), .flag(flag_WEI), .out_ACT(M_ACT[1]), .out_PSUM(M_PSUM[1]));
    PE PE3(.clk(clk), .rst(rst),  .WR_EN(M_WR_EN_1), .PSUM(M_PSUM[1]), .Weight(M_WEI[1]), .out_Weight(M_WEI[2]), .ACT(Act_2), .flag(flag_WEI), .out_ACT(M_ACT[2]), .out_PSUM(M_PSUM[2]));
    PE PE4(.clk(clk), .rst(rst),  .WR_EN(M_WR_EN_0), .PSUM(M_PSUM[2]), .Weight(M_WEI[2]), .out_Weight(), .ACT(Act_3), .flag(flag_WEI), .out_ACT(M_ACT[3]), .out_PSUM(PSUM_0));
    
    PE PE5(.clk(clk), .rst(rst),  .WR_EN(M_WR_EN_3), .PSUM(Zero), .Weight(Weight_1), .out_Weight(M_WEI[3]), .ACT(M_ACT[0]), .flag(flag_WEI), .out_ACT(M_ACT[4]), .out_PSUM(M_PSUM[3]));
    PE PE6(.clk(clk), .rst(rst),  .WR_EN(M_WR_EN_2), .PSUM(M_PSUM[3]), .Weight(M_WEI[3]), .out_Weight(M_WEI[4]), .ACT(M_ACT[1]), .flag(flag_WEI), .out_ACT(M_ACT[5]), .out_PSUM(M_PSUM[4]));
    PE PE7(.clk(clk), .rst(rst),  .WR_EN(M_WR_EN_1), .PSUM(M_PSUM[4]), .Weight(M_WEI[4]), .out_Weight(M_WEI[5]), .ACT(M_ACT[2]), .flag(flag_WEI), .out_ACT(M_ACT[6]), .out_PSUM(M_PSUM[5]));
    PE PE8(.clk(clk), .rst(rst),  .WR_EN(M_WR_EN_0), .PSUM(M_PSUM[5]), .Weight(M_WEI[5]), .out_Weight(), .ACT(M_ACT[3]), .flag(flag_WEI), .out_ACT(M_ACT[7]), .out_PSUM(PSUM_1));
    
    PE PE9 (.clk(clk), .rst(rst), .WR_EN(M_WR_EN_3), .PSUM(Zero), .Weight(Weight_2), .out_Weight(M_WEI[6]), .ACT(M_ACT[4]), .flag(flag_WEI), .out_ACT(M_ACT[8]), .out_PSUM(M_PSUM[6]));
    PE PE10(.clk(clk), .rst(rst), .WR_EN(M_WR_EN_2), .PSUM(M_PSUM[6]), .Weight(M_WEI[6]), .out_Weight(M_WEI[7]), .ACT(M_ACT[5]), .flag(flag_WEI), .out_ACT(M_ACT[9]), .out_PSUM(M_PSUM[7]));
    PE PE11(.clk(clk), .rst(rst), .WR_EN(M_WR_EN_1), .PSUM(M_PSUM[7]), .Weight(M_WEI[7]), .out_Weight(M_WEI[8]), .ACT(M_ACT[6]), .flag(flag_WEI), .out_ACT(M_ACT[10]), .out_PSUM(M_PSUM[8]));
    PE PE12(.clk(clk), .rst(rst), .WR_EN(M_WR_EN_0), .PSUM(M_PSUM[8]), .Weight(M_WEI[8]), .out_Weight(), .ACT(M_ACT[7]), .flag(flag_WEI), .out_ACT(M_ACT[11]), .out_PSUM(PSUM_2));
    
    PE PE13(.clk(clk), .rst(rst), .WR_EN(M_WR_EN_3), .PSUM(Zero), .Weight(Weight_3), .out_Weight(M_WEI[9]), .ACT(M_ACT[8]), .flag(flag_WEI), .out_ACT(), .out_PSUM(M_PSUM[9]));
    PE PE14(.clk(clk), .rst(rst), .WR_EN(M_WR_EN_2), .PSUM(M_PSUM[9]), .Weight(M_WEI[9]), .out_Weight(M_WEI[10]), .ACT(M_ACT[9]), .flag(flag_WEI), .out_ACT(), .out_PSUM(M_PSUM[10]));
    PE PE15(.clk(clk), .rst(rst), .WR_EN(M_WR_EN_1), .PSUM(M_PSUM[10]), .Weight(M_WEI[10]), .out_Weight(M_WEI[11]), .ACT(M_ACT[10]), .flag(flag_WEI), .out_ACT(), .out_PSUM(M_PSUM[11]));
    PE PE16(.clk(clk), .rst(rst), .WR_EN(M_WR_EN_0), .PSUM(M_PSUM[11]), .Weight(M_WEI[11]), .out_Weight(), .ACT(M_ACT[11]), .out_ACT(), .flag(flag_WEI), .out_PSUM(PSUM_3));
    
endmodule
