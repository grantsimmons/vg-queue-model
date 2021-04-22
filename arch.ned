import ned.IdealChannel;
import org.omnetpp.queueing.Classifier;
import org.omnetpp.queueing.PassiveQueue;
import org.omnetpp.queueing.Queue;
import org.omnetpp.queueing.Server;
import org.omnetpp.queueing.Source;
import org.omnetpp.queueing.Sink;

//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

network Arch
{
    parameters:
        int region_count = 3;
        int elo_bin_count = 4; //Automatically calculate based on bins
        //int elo_bins = {600,1200,1500,1800,2200,2700,3200};
         
    submodules:
        region_sources[region_count]: Source {
        }
        
        player_classifier: Classifier {
        }

        region_player_queues[region_count]: PassiveQueue { //PODO Replace with Queue Pool
        }
                
        //region_player_queues[region_count]: RegionalQueue {
        //    num_queues = elo_bin_count;
        //}
        
        lobby_creation: Server {
        }
        
        lobby_classifier: Classifier {
        }
        
        region_lobby_queue[region_count]: PassiveQueue {
        }
        
        region_server[region_count]: Server { //TODO: Replace with Server Pool
        }
        
        sink: Sink {
        }
        //region_server_pool[region_count]: ServerPool {
        //    server_count = num_servers[region_code];
        //}

    connections:
        for i=0..region_count-1 {
            region_sources[i].out --> player_classifier.in++;
            player_classifier.out++ --> region_player_queues[i].in++;
            region_player_queues[i].out++ --> lobby_creation.in++;
            lobby_classifier.out++ --> region_lobby_queue[i].in++;
            region_lobby_queue[i].out++ --> region_server[i].in++;
            region_server[i].out --> sink.in++;
        }
        lobby_creation.out --> lobby_classifier.in++;
        player_classifier.rest --> sink.in++; //Is this right?
        lobby_classifier.rest --> player_classifier.in++;

}
