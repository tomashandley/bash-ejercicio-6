BEGIN{cantCodigo=0;
aperturaComentario=0;
cierreComentario=0;
}
(($1 !~ "//" || index($1,"//") > 1) && ($1 !~ "\/\*" || index($1,"/*") > 1) && $0 != "" && aperturaComentario == 0 && NF){
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
        aperturaComentario = 0;
    }
}
END{
    print cantCodigo;
}