shader_type canvas_item;

uniform sampler2D mask_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
  COLOR = texture(TEXTURE, UV); //read from texture
  COLOR.a *= texture(mask_texture, UV).a; //set blue channel to 1.0
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
