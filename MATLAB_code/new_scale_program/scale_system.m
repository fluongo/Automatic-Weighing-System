classdef scale_system < handle
    %SCALE_SYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % Instantiate the sensor objects
        sensors;
        isrunning = zeros(12,1); % Which sensors are running...
        iswriting = zeros(12,1); % Which sensors are writing...       
        file_ids = [0 0 0 0 0 0 0 0 0 0 0 0 ]; % empty array for file_ids to write files in
    end
    methods
        function obj = scale_system(obj)
            %SCALE_SYSTEM Construct an instance of this class
            %   Detailed explanation goes here
        end
        
        function couple = getCouple(obj, x) % returns coupled sensors for each box
            switch x
                case 1
                    couple = [obj.sensors{1}, obj.sensors{2}];
                case 2
                    couple = [obj.sensors{3}, obj.sensors{4}];
                case 3
                    couple = [obj.sensors{5}, obj.sensors{6}];
                case 4
                    couple = [obj.sensors{7}, obj.sensors{8}];
            end
        end
        
        function setIsRunning(obj, x) % set the starting sensors that will run from 1 to x
            obj.isrunning(1:x) = 1;
        end
        
        function modIsRunning(obj, x, y) % edits which sensors to turn on/off
            obj.isrunning(x) = y;
        end
        
        function isRun = getIsRunning(obj) % returns the array of sensors: isrunning
            isRun = obj.isrunning;
        end
        
        % add sensor objects with respective comports
        function instantiatePorts(obj)
           obj.sensors = {scale_sensor('COM12'), scale_sensor('COM6'), scale_sensor('COM8'), scale_sensor('COM9'), scale_sensor('COM10'), scale_sensor('COM11'), scale_sensor('COM4'), scale_sensor('COM13')} 
        end
            
        function clearPorts(obj) % clears old data 
            clear;
            delete(instrfindall); 
        end
        
        function avg = getAvg(obj, x) % returns average of coupled sensors
            couple = obj.getCouple(x);
            sum = couple(1).readWeight + couple(2).readWeight;
            avg = 100*(sum/2);
        end
        
        function tare(obj, x) % tares the coupled sensors
            couple = obj.getCouple(x);
            couple(1).tareScale();
            couple(2).tareScale();
        end
        
        function setNewCf(obj, x, y) % set the new calibration factor to coupled sensors
            couple = obj.getCouple(x);
            couple(1).sensor1SetCfactor(y);
            couple(2).sensor1SetCfactor(y);            
        end
    end
end

