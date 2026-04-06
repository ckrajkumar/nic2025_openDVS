module reg_pix_rst(
    input clk, rst, en_on, en_off, comp_out, ncomp_out, global_pix_rst, en_pix_rst,
    output evt_on, evt_off,
    output pix_rst
);
wire evt;
reg dout_on, dout_off;
//register for on events
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        dout_on <= 1'b0;
    end
    else begin
        if(en_on) begin
            dout_on <= comp_out;
        end
        else begin
            dout_on <= dout_on;
        end
    end
end

//register for off events
always @(posedge clk or negedge rst) begin
    if(!rst) begin
        dout_off <= 1'b0;
    end
    else begin
        if(en_off) begin
            dout_off <= ncomp_out;
        end
        else begin
            dout_off <= dout_off;
        end
    end
end


assign evt = dout_on | dout_off;
assign evt_on = dout_on;
assign evt_off = dout_off;
assign pix_rst = (evt & en_pix_rst) | global_pix_rst;

endmodule 
