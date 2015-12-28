#include <boost/asio/serial_port.hpp>
#include <boost/asio.hpp>
#include <iostream>
 
using namespace boost; 
asio::io_service io;
asio::serial_port port(io);
void init_char() {
 
port.open("/dev/ttyS2");
port.set_option(asio::serial_port_base::baud_rate(115200));
 
 
// Read 1 character into c, this will block
// forever if no character arrives.
 
 
}
double transform(int read){ return -read * 1.25 / 8192 + 1.65; }

void decode(double &channelA, double &channelB)
{
   int mask = 16383;//0b0011111111111111;
   int signmask = 1<<13;
   int mask2 = mask>>1;

  channelA=0;
channelB=0;
   unsigned char package[4];
	asio::read(port, asio::buffer(package,4));

   // DEBUG
   /*
   package[0] = 32;
   package[1] = 0;
   package[2] = 63;
   package[3] = 255;
   */
   int reads[2] = {0};
  
   reads[0] = (package[0] << 8) | (package[1] & 0xff);
   reads[1] = (package[2] << 8) | (package[3] & 0xff);   
   reads[0] &= mask;
   reads[1] &= mask;
   
   if(reads[0]&signmask){
		reads[0]=(reads[0]&mask2)-8192;
	}
   if(reads[1]&signmask){
                reads[1]=(reads[1]&mask2)-8192;
        }

  
   channelA = transform(reads[0]);
   channelB = transform(reads[1]);


}

int main(){
const int reads = 1000000;
const int lel[4] = {1,0,3,2};
char tab[4];
init_char();
double A,B;
for(int k = 0; k < reads; ++k){
	decode(A,B);	
	std::cout << "A: "<<A<<"  B: "<<B<<std::endl;

/*
	asio::read(port, asio::buffer(tab,4));
	for(int j=0;j<4;++j){
	char c=tab[j];
	for(int i=128;i>0;i/=2){
		if(c&i)
			std::cout<< 1;
		else
			std::cout<<0;
		if(i==1) break;
	}
	std::cout<<" ";
  }
	std::cout<<std::endl;
	
*/
}
return 0;
}
