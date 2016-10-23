difference() {
	translate([-5, -5, 0])
		cube([105, 90, 2.4]);
	union() {
		translate([-2.5, -2.5, 0])
			cylinder(d=3, h=12.4, $fn=100);
		translate([105 -5 -2.5, -2.5, 0])
			cylinder(d=3, h=12.4, $fn=100);
		translate([-2.5, 90 -5 -2.5, 0])
			cylinder(d=3, h=12.4, $fn=100);
		translate([105 -5 -2.5, 90 -5 -2.5, 0])
			cylinder(d=3, h=12.4, $fn=100);
	}
}