--[[
key_value_sort.lua

@Author: Ian Britz
@Date  : 08/20/2018

Dependencies: json.lua

Inputs: Two JSON files containing key-value pairs of strings.

Output: One JSON file containing two sections: one containing the key-value
pairs common to both input files and one containing the key-value pairs that 
are different in both input files.

*Duplicate key-value pairs will be listed only once.

*The input files may contain empty JSON lists, but they cannot be purely empty files.

*It is assumed the input files do not contain multiple values for a single key. If so
the program will execute normally, but only one value will be shown for any one key.

*If no key-value pairs are shared between the files, or no key-value pairs are unique,
the program will execute normally, but display "nil": "nil" for the relevant section.
]]--


json = require "json"

--Reads two JSON files and saves the contents into a table.
local function read_JSON(in_file1, in_file2)
	 json_input = {{},{}}
	 
	 for i,file in ipairs({in_file1, in_file2}) do
		 io.input(file)
		 file_contents = io.read("*all")
		 json_input[i] = json.parse(file_contents)
	 end
	 
	 return json_input
end

--Determines which values in the lists are unique and separates them.
local function separate_key_value_pairs(json_input)
	 json_output = {{},{}}
	 
	 for i = 0, 1, 1 do
		 for key,value in pairs(json_input[1 + i]) do
			 if json_input[2 + -i][key] ~= nil then
				 table.insert(json_output[1], ('\t\t"'..key..'": '..'"'..value..'",\n'))
				 json_input[2 + -i][key] = nil
			 else
				 table.insert(json_output[2], ('\t\t"'..key..'": '..'"'..value..'",\n'))
			 end
		 end
	 end
	 
	 return json_output

end

--Correctly formats the output for a JSON file.
local function output_JSON(json_output, out_file)

	 output = io.open(out_file, "w")
	 io.output(output)
	 
	 io.write('{\n\t"Common Key-Value Pairs": {\n')
	 
	 for i = 1, 2, 1 do
	 
		 if next(json_output[i]) == nil then
			 io.write(('\t\t"nil": "nil",\n'))
		 else
			 list = json_output[i]
			 list[#list] = list[#list]:sub(1, -3)..'\n'
			 for k, v in pairs(json_output[i]) do
				 io.write(v)
			 end
		 end
		 
		 if i == 1 then 
			io.write('\t}\n{\n\t"Unique Key-Value Pairs": {\n') 
		 end
		 
	 end
	 io.write('\t}\n}')
	 io.close(output)
	 
end

--Modularized main function for ease of testing .
local function main(in_file1, in_file2, out_file)

     json_input = read_JSON(in_file1, in_file2)
	 
	 json_output = separate_key_value_pairs(json_input)

	 output_JSON(json_output, out_file)
	 
	 print("Program completed successfully.")
	 
end

--Files hard-coded below for ease of executing the program.
main("input1.json", "input2.json", "output.json")
