extrsave:{[t;par;forexdb_addr_];
 forexdb_addr:forexdb_addr_;
 parday:par[0];
 parsym:par[1];

 extr:select from t where time.date=parday,symbol=parsym;
 addr:forexdb_addr,"/",(string parsym),"/",(string parday),"/forex_quote/";
 0N!addr:`$addr;
 0N!.[addr;();,;extr]
 }

ptrunk:{[forexdb_addr_;x];
 forexdb_addr:forexdb_addr_;
 forex_addr:forexdb_addr,"/forex_taq";
 forex_quote:flip `symbol`time`bid`ask!("SZFF";",") 0: x;
 forex_quote:.Q.en[`$forex_addr] forex_quote; 
 symlist: exec distinct symbol from forex_quote;
 daylist: exec distinct time.date from forex_quote;
 parlist: daylist cross symlist;
 k:0;
 do[count parlist;
    extrsave[forex_quote;parlist[k];forexdb_addr];
    k+:1;
 ];
 
 / update par.txt dynamically
 tempaddr:1_forexdb_addr,"/";
 :tempaddr ,/: string symlist
 }


data_addr:":",getenv `DATA;
forexdb_addr:data_addr,"/forex_taqDB";
forex_addr:forexdb_addr,"/forex_taq";
partxt_addr:forex_addr,"/par.txt";

parlist:`char$();

filedate:2009.05m;
symbolc:"USDJPY";
do[52;
   file_addr:data_addr,"/forex_temp/",symbolc,((string filedate) _ 4),".csv";

   .Q.fs[{parlist::distinct parlist,ptrunk[forexdb_addr;x]}] `$file_addr; 
   if[0~count key `$partxt_addr;(`$partxt_addr) 0: asc parlist;];
   if[1~count key `$partxt_addr;
    parsymlist:read0 `$partxt_addr;
    parlist:asc distinct parsymlist,parlist;
    (`$partxt_addr) 0: parlist;];
   0N!filedate:filedate+1;
   ];

