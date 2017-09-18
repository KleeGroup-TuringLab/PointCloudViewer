$fn=128;
$fa=0.5;

//translate([0,0,0]) cube([,,]);
hauteur=36;

module colson_a() {
  translate([0,-3,0]) cube([8,3,7], center=true);
}

module colson_b() {
  difference() {
    cylinder(d=8, h=4, center=true);
    cylinder(d=5.5, h=5, center=true);
  }
}

difference() {
  union() {
    // -9 pour gain en vitesse d'impression
    translate([13.5,16-5/2-1.5,0]) cube([25+32-7,8,hauteur], center=true);
    translate([28.5,16-7,0]) cube([8.5,4,hauteur], center=true);
    cylinder(d=32, h=hauteur, center=true);
    // colsons
    translate([-7,18,hauteur/4]) colson_a();
    translate([ 4,18,hauteur/4]) colson_a();
    translate([15,18,hauteur/4]) colson_a();
    translate([-7,18,-hauteur/4]) colson_a();
    translate([ 4,18,-hauteur/4]) colson_a();
    translate([15,18,-hauteur/4]) colson_a();
  }
  // passe tube aspiration
  cylinder(d=28, h=hauteur+2, center=true);
  // dégagement tube aspiration (-24 vs -20 pour clipser)
  rotate([0,0,40]) translate([-23,-24,-(hauteur+2)/2])
    cube([40,20,hauteur+2], center=false);
  // Fixations
  rotate([90,0,0]) translate([28.5,hauteur/4,-13])
    cylinder(d=6.5, h=16, center=true);
  rotate([90,0,0]) translate([28.5,-hauteur/4,-13])
    cylinder(d=6.5, h=16, center=true);
  // colsons
  translate([-7,18,hauteur/4]) colson_b();
  translate([ 4,18,hauteur/4]) colson_b();
  translate([15,18,hauteur/4]) colson_b();
  translate([-7,18,-hauteur/4]) colson_b();
  translate([ 4,18,-hauteur/4]) colson_b();
  translate([15,18,-hauteur/4]) colson_b();
}

