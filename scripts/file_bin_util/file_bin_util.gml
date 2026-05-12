//This should've been in the engine in the first place [british accent]
#macro FILE_READ 0
#macro FILE_WRITE 1
#macro FILE_READ_WRITE 2

// =====================================================================================
// 8 Bit functions
// =====================================================================================
function file_bin_read_int8(file)
{
	var result = file_bin_read_byte(file);
	return result > 127 ? result - 256 : result;
}

function file_bin_read_uint8(file)
{
	return file_bin_read_byte(file);
}

// =====================================================================================
// 16 Bit functions
// =====================================================================================
function file_bin_write_int16(file, number)
{
	for (var i = 0; i < 2; ++i) 
	{
		file_bin_write_byte(file, floor(number / power(0x100, 1 - i)) % 0x100);
	}
}

function file_bin_read_int16(file)
{
	var result = file_bin_read_uint16(file);
	return result > 32767 ? result - 65535 : result;
}

function file_bin_read_uint16(file)
{
	var result = 0;
	
	for (var i = 0; i < 2; ++i) 
	{
	    var byte = (file_bin_read_byte(file) & 0xFF) << 8 * (1 - i);
		result |= byte;
	}	
	
	return result;
}

// =====================================================================================
// 32 Bit functions
// =====================================================================================
function file_bin_write_int32(file, number)
{
	for (var i = 0; i < 4; ++i) 
	{
		file_bin_write_byte(file, floor(number / power(0x100, 3 - i)) % 0x100);
	}
}

function file_bin_read_int32(file)
{
	var result = file_bin_read_uint32(file);
	return result > 2147483647 ? result - 4294967295 : result;
}

function file_bin_read_uint32(file)
{
	var result = 0;
	
	for (var i = 0; i < 4; ++i) 
	{
	    var byte = (file_bin_read_byte(file) & 0xFF) << 8 * (3 - i);
		result |= byte;
	}	
	
	return result;
}