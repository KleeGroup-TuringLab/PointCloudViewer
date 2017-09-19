$fn = 50;
r=14.1;
r1=1.7;

// Diamètre extérieur tube : 26.2
// Diamètre interne tube : 24
// Pas : 7

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

union() {

    difference() {
      union() {
        // -9 pour gain en vitesse d'impression
        translate([13.5-10,16-5/2-1.5,0]) cube([25+32+10,8,hauteur], center=true);
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
      // Fixations outils
      rotate([90,0,0]) translate([-22,hauteur/4,-13])
        cylinder(d=6.5, h=16, center=true);
      rotate([90,0,0]) translate([-22,-hauteur/4,-13])
        cylinder(d=6.5, h=16, center=true);
    }

    translate([0,0,-hauteur/2])
    difference() { 
        union() {
            // Cylindre interne
            cylinder(d=30, h=hauteur, center=false);
        }
        translate([0,0,-1])
        union() {
          // Passage intérieur
          cylinder(d=24, h=hauteur+2);
          // Filetage bas
          linear_extrude(height = 7 * 6, center = false, convexity = 10, twist = -360 * 6, $fn = 100)
            polygon([
                [(r - r1 + r1 * sin(  0)) * cos(  0), (r - r1 + r1 * sin(  0)) * sin(  0)],
                [(r - r1 + r1 * sin( 10)) * cos( 10), (r - r1 + r1 * sin( 10)) * sin( 10)],
                [(r - r1 + r1 * sin( 20)) * cos( 20), (r - r1 + r1 * sin( 20)) * sin( 20)],
                [(r - r1 + r1 * sin( 30)) * cos( 30), (r - r1 + r1 * sin( 30)) * sin( 30)],
                [(r - r1 + r1 * sin( 40)) * cos( 40), (r - r1 + r1 * sin( 40)) * sin( 40)],
                [(r - r1 + r1 * sin( 50)) * cos( 50), (r - r1 + r1 * sin( 50)) * sin( 50)],
                [(r - r1 + r1 * sin( 60)) * cos( 60), (r - r1 + r1 * sin( 60)) * sin( 60)],
                [(r - r1 + r1 * sin( 70)) * cos( 70), (r - r1 + r1 * sin( 70)) * sin( 70)],
                [(r - r1 + r1 * sin( 80)) * cos( 80), (r - r1 + r1 * sin( 80)) * sin( 80)],
                [(r - r1 + r1 * sin( 90)) * cos( 90), (r - r1 + r1 * sin( 90)) * sin( 90)],
                [(r - r1 + r1 * sin(100)) * cos(100), (r - r1 + r1 * sin(100)) * sin(100)],
                [(r - r1 + r1 * sin(110)) * cos(110), (r - r1 + r1 * sin(110)) * sin(110)],
                [(r - r1 + r1 * sin(120)) * cos(120), (r - r1 + r1 * sin(120)) * sin(120)],
                [(r - r1 + r1 * sin(130)) * cos(130), (r - r1 + r1 * sin(130)) * sin(130)],
                [(r - r1 + r1 * sin(140)) * cos(140), (r - r1 + r1 * sin(140)) * sin(140)],
                [(r - r1 + r1 * sin(150)) * cos(150), (r - r1 + r1 * sin(150)) * sin(150)],
                [(r - r1 + r1 * sin(160)) * cos(160), (r - r1 + r1 * sin(160)) * sin(160)],
                [(r - r1 + r1 * sin(170)) * cos(170), (r - r1 + r1 * sin(170)) * sin(170)],
                [(r - r1 + r1 * sin(180)) * cos(180), (r - r1 + r1 * sin(180)) * sin(180)]
            ]);
        }
    }
}