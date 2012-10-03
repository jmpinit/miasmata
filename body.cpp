#include <string>
#include "body.h"

void Body::init(int _x, int _y) {
    x = _x;
    y = _y;
}

void Body::update() {
    
}

int Body::get_x() {
    return x;
}

int Body::get_y() {
    return y;
}
