transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/sizul/Desktop/Universidad/Uniandes/sistemas_electronicosdigitales/designproblems-labs/DP_M09/Entrega/Anexo\ 1\ -\ Codigo/rtl {C:/Users/sizul/Desktop/Universidad/Uniandes/sistemas_electronicosdigitales/designproblems-labs/DP_M09/Entrega/Anexo 1 - Codigo/rtl/uDATAPATH.v}
vlog -vlog01compat -work work +incdir+C:/Users/sizul/Desktop/Universidad/Uniandes/sistemas_electronicosdigitales/designproblems-labs/DP_M09/Entrega/Anexo\ 1\ -\ Codigo/rtl {C:/Users/sizul/Desktop/Universidad/Uniandes/sistemas_electronicosdigitales/designproblems-labs/DP_M09/Entrega/Anexo 1 - Codigo/rtl/SC_STATEMACHINE.v}
vlog -vlog01compat -work work +incdir+C:/Users/sizul/Desktop/Universidad/Uniandes/sistemas_electronicosdigitales/designproblems-labs/DP_M09/Entrega/Anexo\ 1\ -\ Codigo/rtl {C:/Users/sizul/Desktop/Universidad/Uniandes/sistemas_electronicosdigitales/designproblems-labs/DP_M09/Entrega/Anexo 1 - Codigo/rtl/SC_RegSHIFTER.v}
vlog -vlog01compat -work work +incdir+C:/Users/sizul/Desktop/Universidad/Uniandes/sistemas_electronicosdigitales/designproblems-labs/DP_M09/Entrega/Anexo\ 1\ -\ Codigo/rtl {C:/Users/sizul/Desktop/Universidad/Uniandes/sistemas_electronicosdigitales/designproblems-labs/DP_M09/Entrega/Anexo 1 - Codigo/rtl/SC_RegGENERAL.v}
vlog -vlog01compat -work work +incdir+C:/Users/sizul/Desktop/Universidad/Uniandes/sistemas_electronicosdigitales/designproblems-labs/DP_M09/Entrega/Anexo\ 1\ -\ Codigo/rtl {C:/Users/sizul/Desktop/Universidad/Uniandes/sistemas_electronicosdigitales/designproblems-labs/DP_M09/Entrega/Anexo 1 - Codigo/rtl/CC_MUXX.v}
vlog -vlog01compat -work work +incdir+C:/Users/sizul/Desktop/Universidad/Uniandes/sistemas_electronicosdigitales/designproblems-labs/DP_M09/Entrega/Anexo\ 1\ -\ Codigo/rtl {C:/Users/sizul/Desktop/Universidad/Uniandes/sistemas_electronicosdigitales/designproblems-labs/DP_M09/Entrega/Anexo 1 - Codigo/rtl/CC_DECODER.v}
vlog -vlog01compat -work work +incdir+C:/Users/sizul/Desktop/Universidad/Uniandes/sistemas_electronicosdigitales/designproblems-labs/DP_M09/Entrega/Anexo\ 1\ -\ Codigo/rtl {C:/Users/sizul/Desktop/Universidad/Uniandes/sistemas_electronicosdigitales/designproblems-labs/DP_M09/Entrega/Anexo 1 - Codigo/rtl/CC_ALU.v}
vlog -vlog01compat -work work +incdir+C:/Users/sizul/Desktop/Universidad/Uniandes/sistemas_electronicosdigitales/designproblems-labs/DP_M09/Entrega/Anexo\ 1\ -\ Codigo {C:/Users/sizul/Desktop/Universidad/Uniandes/sistemas_electronicosdigitales/designproblems-labs/DP_M09/Entrega/Anexo 1 - Codigo/BB_SYSTEM.v}

vlog -vlog01compat -work work +incdir+C:/Users/sizul/Desktop/Universidad/Uniandes/sistemas_electronicosdigitales/designproblems-labs/DP_M09/Entrega/Anexo\ 1\ -\ Codigo/simulation/modelsim {C:/Users/sizul/Desktop/Universidad/Uniandes/sistemas_electronicosdigitales/designproblems-labs/DP_M09/Entrega/Anexo 1 - Codigo/simulation/modelsim/TB_SYSTEM.vt}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  TB_SYSTEM

add wave *
view structure
view signals
run -all
