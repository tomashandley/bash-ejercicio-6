BEGIN{cantCodigo=0;
aperturaComentario=0;
cierreComentario=0;
}
($1 !~ "//" && $1 !~ "\/\*" && $NF !~ "\*\/" && $0 != ""){
    cantCodigo++;
}
$0 ~ "\/\*" && $0 !~ "\*\/"{
    if(aperturaComentario == 0){
        aperturaComentario = NR;
    }
}
$0 !~ "\/\*" && $0 ~ "\*\/"{
    if(aperturaComentario > 0){
        cierreComentario = NR;
        cantCodigo -= (cierreComentario - aperturaComentario + 1);
        if(cantCodigo < 0)
            cantCodigo = 0;
        aperturaComentario = 0;
    }
}
END{
    print cantCodigo;
}