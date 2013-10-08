extrsave1:{[t;par];
 parday:par[0];
 parsym:par[1];

 extr:select from t where day=parday,symbol=parsym;

 addr: "/" sv(string parsym;string parday;"trade";"");
 addr: "" sv(string `:;addr);
 addr: `$addr;

 0N!.[addr;();,;extr]
 }

ptrunk:{
 trade:flip `symbol`day`time`price`volume`g127`corr`cond`ex!("SDTFIIIcS";",") 0: x;
 trade:.Q.en[`:USTAQ] trade; 
 symlist: exec distinct symbol from trade;
 daylist: exec distinct day from trade;
 parlist: daylist cross symlist;
 k:0;
 do[count parlist;
    extrsave1[trade;parlist[k]];
    k+:1;
 ];
 
 / update par.txt dynamically
 :"/home/brandon/VSCHON/V_KDB/scratch/" ,/: string symlist
 }

parlist:`char$();

.Q.fs[{parlist::distinct parlist,ptrunk x}] `:trade.csv; 
if[0~count key `:USTAQ/par.txt;`:USTAQ/par.txt 0: asc parlist;];
if[1~count key `:USTAQ/par.txt;
 parsymlist:read0 `:USTAQ/par.txt;
 parlist:asc distinct parsymlist,parlist;
 `:USTAQ/par.txt 0: parlist;];


