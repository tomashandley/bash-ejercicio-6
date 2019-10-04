BEGIN{cantComentario=0;
aperturaComentario=0;
cierreComentario=0;
}
($1=="/*" && $NF=="*/") || ($1 ~ "\/\*" && $NF ~ "\*\/") || $0~"//" || ($0 ~ "\/\*" && $0 ~ "\*\/"){
    cantComentario++;
}
$0 ~ "\/\*" && $0 !~ "\*\/"{
    if(aperturaComentario == 0){
        aperturaComentario = NR;
        #print "aperturaComentario "NR;
    }
}
$0 !~ "\/\*" && $0 ~ "\*\/"{
    if(aperturaComentario > 0){
        cierreComentario = NR;
        #print "cierreComentario "NR;
        cantComentario += (cierreComentario - aperturaComentario + 1);
        cantCodigo -= (cierreComentario - aperturaComentario);
        aperturaComentario = 0;
    }
}
END{
    print cantComentario;
}