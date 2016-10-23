difference() {
	translate([-5, -5, 0])
		cube([105, 90, 12.4]);
	union() {
		translate([43, 3, 0])
			// ESP 8266
			union() {
				cube([49, 27, 11.5]);
				translate([0, 4.5, 0])
					cube([60, 18, 14]);
			}

		translate([5.5, 33, 0])
			// LCD
			union() {
				cube([84, 44, 10]);
				translate([4, 13, 0])
					cube([73, 25, 14]);
			}
		
		translate([5.5, 10, 0])
			cube([84, 14, 10]);
		translate([5.5, 10, 0])
			cube([30, 34, 10]);
		
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