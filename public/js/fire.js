Fire = function(buffer, _parameters){
	var
		_this = this,
		parameters = {
			intensity: 0.4, // 0-1
			dropRows: 4
		},
		bufferWidth = buffer.width,
		bufferHeight = buffer.height,
		colors = [],
		out = [],
		mask = null
	;
 
	$.extend(parameters, _parameters);
 
	function init(){
		createPalette();
		resetOut();
	}
 
	function createPalette(){
		// build a palette
		for (var i = 0; i < 32; ++i)
		{
			/* black to blue, 32 values*/
			colors[i] = {
				r: 0,
				g: 0,
				b: i << 1,
				a: i
			}
 
			/* blue to red, 32 values*/
			colors[i + 32] = {
				r: i << 3,
				g: 0,
				b: 64 - (i << 1),
				a: i+32
			}
 
			/*red to yellow, 32 values*/
			colors[i + 64] = {
				r: 255,
				g: i << 3,
				b: 0,
				a: i+64
			}
 
			/* yellow to white, 162 */
			colors[i + 96] = {
				r: 255,
				g: 255,
				b: i << 2,
				a: i+96
			}
 
			colors[i + 128] = {
				r: 255,
				g: 255,
				b: 64 + (i << 2),
				a: i+128
			}
 
			colors[i + 160] = {
				r: 255,
				g: 255,
				b: 128 + (i << 2),
				a: i+160
			}
 
			colors[i + 192] = {
				r: 255,
				g: 255,
				b: 192 + i,
				a: i+192
			}
 
			colors[i + 224] = {
				r: 255,
				g: 255,
				b: 224 + i,
				a: i+224
			}
		}
	}
 
	function resetOut(){
		// Fill out with zeros
		for( var y = 0; y < bufferHeight; y++ ){ // Rows
			for( var x = 0; x < bufferWidth; x++ ){ // Columns
				out[y*bufferWidth+x] = 0;
			}
		}
	}
 
	this.frame = function(){
 
		var j = bufferWidth * (bufferHeight - 1);
 
		for(var i = 0; i < bufferWidth; i++){
			if(Math.random() < parameters.intensity){
				out[j + i] = 255;
			}
			else {
				out[j + i] = 0;
			}
		}
 
		for(var y = 0; y < 60; ++y){
			for(var x = 0; x < bufferWidth; ++x){
 
				var j_plus_x = j + x;
 
				// Calculate intensity
				var temp;
				if(x == 0){
					temp = out[j];
					temp += out[j + 1];
					temp += out[j - bufferWidth];
					temp /= 3;
				}
				else if(i == bufferWidth - 1){
					temp = out[j + 1];
					temp += out[j - bufferWidth + x];
					temp += out[j_plus_x - 1];
					temp /= 3;
				}
				else{
					temp = out[j_plus_x];
					temp += out[j_plus_x + 1];
					temp += out[j_plus_x - 1];
					temp += out[j_plus_x - bufferWidth];
					temp >>= 2;
				}
 
				// Decay
				if(temp > 1){
					temp -= 1;
				}
 
				temp <<= 0;
 
				// Set pixel
				out[j_plus_x - bufferWidth] = temp;
 
				var id = j_plus_x << 2; // (pixels per row * rows down + place on current row) * number of channels (4)
				buffer.data[id    ] = colors[temp].r; // Red
				buffer.data[id + 1] = colors[temp].g; // Green
				buffer.data[id + 2] = colors[temp].b; // Blue
 
				if(mask) buffer.data[id + 3] = mask.data[id + 3]; // Alpha
				else buffer.data[id + 3] = colors[temp].a; // Alpha 
			}
			j -= bufferWidth;
		}
 
	}
 
	this.setBuffer = function(_buffer){
		buffer = _buffer;
		bufferWidth = _buffer.width;
		bufferHeight = _buffer.height;
		resetOut();
	}
 
	this.setParameter = function(p,value){
		if(parameters[p] !== undefined){
			parameters[p] = value;
		}
	}
 
	this.getParameters = function(){
		return parameters;
	}
 
	this.setMask = function(_mask){
		mask = _mask;
	}
 
	init();
 
}