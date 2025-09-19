classdef Gen_ima_mov
    % 实现在噪点中出现特定方形刺激的windows XP屏幕保护动画效果
    properties
        origpx
        edgepx
        laypx
        x
        xstatus = 1;
        y
        ystatus = 1;
        noisy
        ima
        contrast
        
        frame = 1;
        refreshrate = 4;
        enlarge_rate = 1.35;
        tobechk = {'x','y'};
    end
    
    methods
        function obj = Gen_ima_mov(ima,contrast)
            validateattributes(ima, {'numeric'}, {'3d'});
            obj.ima = uint8(ima);
            obj.contrast = contrast;
            [obj.origpx,obj.laypx] = size(ima,[2 3]);
            obj.edgepx = round(obj.origpx * obj.enlarge_rate);
            obj.x = randi(obj.edgepx - obj.origpx + 1);
            obj.y = randi(obj.edgepx - obj.origpx + 1);
            obj = obj.draw_ima;
        end
        
        function obj = draw_ima(obj)
            obj.noisy = randi([0, 255], obj.edgepx, obj.edgepx, obj.laypx, 'uint8');
            for i = 1:obj.laypx
                temp = (1 - obj.contrast) * randi([0, 255], obj.origpx, obj.origpx, 'uint8') + ...
                    obj.contrast * obj.ima(:,:,i);
                obj.noisy(obj.x:obj.x+obj.origpx-1, obj.y:obj.y+obj.origpx-1, i) = temp;
            end
        end
        
        function obj = update_frame(obj)
            if obj.frame < obj.refreshrate
                obj.frame = obj.frame + 1;
            else
                obj = obj.update_position;
                obj = obj.draw_ima;
                obj.frame = 1;
            end
        end
        
        function obj = update_position(obj)
            obj = obj.boundary_chk;
            obj.x = obj.x+obj.xstatus;%(-1)^round(rand(1));
            obj.y = obj.y+obj.ystatus;%(-1)^round(rand(1));
        end
        
        function obj = boundary_chk(obj)
            for i = 1:length(obj.tobechk)
                if obj.(obj.tobechk{i}) == 1
                    obj.([obj.tobechk{i} 'status']) = 1;
                elseif obj.(obj.tobechk{i}) == obj.edgepx-obj.origpx+1
                    obj.([obj.tobechk{i} 'status']) = -1;
                end
            end
        end
        
    end
end

