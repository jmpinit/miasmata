#include "entity.h"

#ifndef BODY
#define BODY

class Body: public Entity {
    private:
        
    public:
        Body(float x, float y, float vx, float vy): Entity(x, y, vx, vy) {
            
        }
        
        void update();
};

#endif
