#ifndef ENTITY
#define ENTITY

class Entity {
    private:
        float x, y, vx, vy;
        unsigned int width, height;
    public:
        static const float MAX_SPEED = 8.0;
        
        Entity(float _x, float _y, float _vx, float _vy) {
            x = _x;
            y = _y;
            vx = _vx;
            vy = _vy;
        }
        
        float get_x();
        float get_y();
        float get_vx();
        float get_vy();
};

#endif
