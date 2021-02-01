CARAVEL_ROOT?=/home/ma/ef/Caravel_Fault_SPM

migrate:
	# Verilog Views
	mkdir -p $(CARAVEL_ROOT)/verilog/rtl/user_project
	mkdir -p $(CARAVEL_ROOT)/verilog/dft/user_project
	mkdir -p $(CARAVEL_ROOT)/verilog/gl/user_project

	yes | cp -a -rf verilog/gl $(CARAVEL_ROOT)/verilog/gl/user_project
	yes | cp -a verilog/gl/user_project_wrapper.v  $(CARAVEL_ROOT)/verilog/gl/user_project_wrapper.v
	yes | cp -a verilog/rtl/user_project_wrapper.v  $(CARAVEL_ROOT)/verilog/rtl/user_project_wrapper.v
	yes | cp -r verilog/rtl/*.v $(CARAVEL_ROOT)/verilog/rtl/user_project
	yes | cp -r verilog/dft/*.v $(CARAVEL_ROOT)/verilog/dft/user_project

	# Physical views
	yes | cp -a def/*.def $(CARAVEL_ROOT)/def/
	yes | cp -a lef/*.lef $(CARAVEL_ROOT)/lef/
	yes | cp -a mag/*.mag $(CARAVEL_ROOT)/mag/
	yes | cp -a -rf gds/*.gds $(CARAVEL_ROOT)/gds/
	
