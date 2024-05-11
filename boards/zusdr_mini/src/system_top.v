`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/02 18:02:05
// Design Name: 
// Module Name: system_top
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
//////////////////////////////////////////////////////////////////////////////////


module system_top(
    input               phy_data_clk_p,
    input               phy_data_clk_n,
    input       [5:0]   phy_rx_data_p,
    input       [5:0]   phy_rx_data_n,
    input               phy_rx_frame_p,
    input               phy_rx_frame_n,
    output              phy_fb_clk_p,
    output              phy_fb_clk_n,
    output      [5:0]   phy_tx_data_p,
    output      [5:0]   phy_tx_data_n,
    output              phy_tx_frame_p,
    output              phy_tx_frame_n,
    output              phy_txnrx,
    output              phy_enable,
    output              phy_en_agc,

    input       [7:0]   phy_ctrl_out,
    output      [3:0]   phy_ctrl_in,

    input               phy_clk_out,
    output              phy_sync_in,

    inout               phy_spi_clk,
    inout               phy_spi_di,
    inout               phy_spi_do,
    inout               phy_spi_enb,
    output              phy_resetb,

    output              pwr_en_phy,

    inout               mon_i2c_scl,
    inout               mon_i2c_sda,

    inout               rom_i2c_scl,
    inout               rom_i2c_sda,

    input               pl_clk,
    input               pl_key,

    input       [3:0]   phy_gpo
);

    wire        [94:0]  emio_gpio_tri_i;
    wire        [94:0]  emio_gpio_tri_o;
    wire        [94:0]  emio_gpio_tri_t;
    wire                emio_i2c0_scl_i;
    wire                emio_i2c0_scl_o;
    wire                emio_i2c0_scl_t;
    wire                emio_i2c0_sda_i;
    wire                emio_i2c0_sda_o;
    wire                emio_i2c0_sda_t;
    wire                emio_i2c1_scl_i;
    wire                emio_i2c1_scl_o;
    wire                emio_i2c1_scl_t;
    wire                emio_i2c1_sda_i;
    wire                emio_i2c1_sda_o;
    wire                emio_i2c1_sda_t;
    wire                emio_spi0_io0_i;
    wire                emio_spi0_io0_o;
    wire                emio_spi0_io0_t;
    wire                emio_spi0_io1_i;
    wire                emio_spi0_io1_o;
    wire                emio_spi0_io1_t;
    wire                emio_spi0_sck_i;
    wire                emio_spi0_sck_o;
    wire                emio_spi0_sck_t;
    wire                emio_spi0_ss_i;
    wire                emio_spi0_ss_o;
    wire                emio_spi0_ss_t;
    wire                gps_pps;
    wire                tdd_sync_i;
    wire                tdd_sync_o;
    wire                tdd_sync_t;
    wire                up_enable;
    wire                up_txnrx;
    wire                xpu_spi_csn;
    wire                xpu_spi_mosi;
    wire                xpu_spi_sclk;


    assign emio_gpio_tri_i[7:0] = phy_ctrl_out[7:0];
    assign emio_gpio_tri_i[16:8] = emio_gpio_tri_o[16:8];
    assign emio_gpio_tri_i[17] = pwr_en_phy;
    assign emio_gpio_tri_i[93:18] = emio_gpio_tri_o[93:18];
    assign emio_gpio_tri_i[94] = pl_key;

    assign phy_ctrl_in[3:0] = emio_gpio_tri_o[11:8];
    assign up_txnrx = emio_gpio_tri_o[12];
    assign up_enable = emio_gpio_tri_o[13];
    assign phy_en_agc = emio_gpio_tri_o[14];
    assign phy_sync_in = emio_gpio_tri_o[15];
    assign phy_resetb = emio_gpio_tri_o[16];
    assign pwr_en_phy = emio_gpio_tri_o[17] | emio_gpio_tri_t[17];

    assign gps_pps = 1'b0;
    assign tdd_sync_i = 1'b0;


    IOBUF mon_i2c_scl_iobuf(
        .I(emio_i2c0_scl_o),
        .IO(mon_i2c_scl),
        .O(emio_i2c0_scl_i),
        .T(emio_i2c0_scl_t)
    );

    IOBUF mon_i2c_sda_iobuf(
        .I(emio_i2c0_sda_o),
        .IO(mon_i2c_sda),
        .O(emio_i2c0_sda_i),
        .T(emio_i2c0_sda_t)
    );

    IOBUF rom_i2c_scl_iobuf(
        .I(emio_i2c1_scl_o),
        .IO(rom_i2c_scl),
        .O(emio_i2c1_scl_i),
        .T(emio_i2c1_scl_t)
    );

    IOBUF rom_i2c_sda_iobuf(
        .I(emio_i2c1_sda_o),
        .IO(rom_i2c_sda),
        .O(emio_i2c1_sda_i),
        .T(emio_i2c1_sda_t)
    );

    IOBUF phy_spi_di_iobuf(
        .I(xpu_spi_mosi),
        .IO(phy_spi_di),
        .O(emio_spi0_io0_i),
        .T(1'b0)
    );

    IOBUF phy_spi_do_iobuf(
        .I(emio_spi0_io1_o),
        .IO(phy_spi_do),
        .O(emio_spi0_io1_i),
        .T(emio_spi0_io1_t)
    );

    IOBUF phy_spi_clk_iobuf(
        .I(xpu_spi_sclk),
        .IO(phy_spi_clk),
        .O(emio_spi0_sck_i),
        .T(1'b0)
    );

    IOBUF phy_spi_enb_iobuf(
        .I(xpu_spi_csn),
        .IO(phy_spi_enb),
        .O(emio_spi0_ss_i),
        .T(1'b0)
    );


    system system_i(
        .emio_gpio_tri_i(emio_gpio_tri_i),
        .emio_gpio_tri_o(emio_gpio_tri_o),
        .emio_gpio_tri_t(emio_gpio_tri_t),
        .emio_i2c0_scl_i(emio_i2c0_scl_i),
        .emio_i2c0_scl_o(emio_i2c0_scl_o),
        .emio_i2c0_scl_t(emio_i2c0_scl_t),
        .emio_i2c0_sda_i(emio_i2c0_sda_i),
        .emio_i2c0_sda_o(emio_i2c0_sda_o),
        .emio_i2c0_sda_t(emio_i2c0_sda_t),
        .emio_i2c1_scl_i(emio_i2c1_scl_i),
        .emio_i2c1_scl_o(emio_i2c1_scl_o),
        .emio_i2c1_scl_t(emio_i2c1_scl_t),
        .emio_i2c1_sda_i(emio_i2c1_sda_i),
        .emio_i2c1_sda_o(emio_i2c1_sda_o),
        .emio_i2c1_sda_t(emio_i2c1_sda_t),
        .emio_spi0_io0_i(emio_spi0_io0_i),
//        .emio_spi0_io0_o(emio_spi0_io0_o),
        .emio_spi0_io0_t(emio_spi0_io0_t),
        .emio_spi0_io1_i(emio_spi0_io1_i),
        .emio_spi0_io1_o(emio_spi0_io1_o),
        .emio_spi0_io1_t(emio_spi0_io1_t),
        .emio_spi0_sck_i(emio_spi0_sck_i),
//        .emio_spi0_sck_o(emio_spi0_sck_o),
        .emio_spi0_sck_t(emio_spi0_sck_t),
        .emio_spi0_ss_i(emio_spi0_ss_i),
//        .emio_spi0_ss_o(emio_spi0_ss_o),
        .emio_spi0_ss_t(emio_spi0_ss_t),
        .enable(phy_enable),
        .gpio_status(phy_ctrl_out),
        .gps_pps(gps_pps),
        .rx_clk_in_n(phy_data_clk_n),
        .rx_clk_in_p(phy_data_clk_p),
        .rx_data_in_n(phy_rx_data_n),
        .rx_data_in_p(phy_rx_data_p),
        .rx_frame_in_n(phy_rx_frame_n),
        .rx_frame_in_p(phy_rx_frame_p),
        .tdd_sync_i(tdd_sync_i),
        .tdd_sync_o(tdd_sync_o),
        .tdd_sync_t(tdd_sync_t),
        .tx_clk_out_n(phy_fb_clk_n),
        .tx_clk_out_p(phy_fb_clk_p),
        .tx_data_out_n(phy_tx_data_n),
        .tx_data_out_p(phy_tx_data_p),
        .tx_frame_out_n(phy_tx_frame_n),
        .tx_frame_out_p(phy_tx_frame_p),
        .txnrx(phy_txnrx),
        .up_enable(up_enable),
        .up_txnrx(up_txnrx),
        .xpu_spi_csn(xpu_spi_csn),
        .xpu_spi_mosi(xpu_spi_mosi),
        .xpu_spi_sclk(xpu_spi_sclk)
    );

endmodule
