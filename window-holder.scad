WIDTH = 44;
HEIGHT = 90;
DEPTH1 = 15;

WEDGE_WIDTH1 = 23;
WEDGE_WIDTH2 = 19;
WEDGE_DEPTH =  33;

WEDGE_HEIGHT = 65;

DISTANCE_TO_CENTER1 = (WIDTH - WEDGE_WIDTH1) / 2.;

TEXT_DEPTH = 3;
FONT_SIZE = 10;

/* * * * * * * * * * * * */



window_holder(is_left=true);

window_holder(is_left=false);



module window_holder(is_left) {
    mirror_if_left(is_left)
        translate([0., 10., 0.])
            difference() {
                union() {
                    cube([WIDTH, DEPTH1, HEIGHT]);

                    translate([DISTANCE_TO_CENTER1, DEPTH1, HEIGHT - WEDGE_HEIGHT])
                        prisma_trapez(WEDGE_WIDTH1, WEDGE_WIDTH2, WEDGE_DEPTH, WEDGE_HEIGHT);
                }

                letter(is_left);
            }
}

module mirror_if_left(is_left) {
    if(is_left)
        mirror([0., 1., 0.])
            children();
    else
        children();
}

module letter(is_left=true) {
    lr_letter = is_left ? "L" : "R";
    flip_it = is_left ? 180. : 0.;

    translate([WIDTH/ 2., DEPTH1 / 2., HEIGHT - TEXT_DEPTH + 0.1])
        linear_extrude(TEXT_DEPTH)
            mirror_if_left(is_left)  // stupid workaround to mirror back the letter again
                rotate([0., 0., flip_it])
                    text(lr_letter, FONT_SIZE, "Arial", valign="center", halign="center");
}


module prisma_trapez(width1, width2, depth, height) {
    /*
     * Note: width1 > width2
     */
    difference() {
        cube([width1, depth, height]);
        alpha = atan((width1 - width2) / 2 / depth);
        translate([width1, 0., -height])
            rotate([0., 0., alpha])
                cube([width1, 2 * depth, 3 * height]);
        translate([0., 0., -height])
            mirror([1., 0., 0.])
                rotate([0., 0., alpha])
                    cube([width1, 2 * depth, 3 * height]);
    }
}
