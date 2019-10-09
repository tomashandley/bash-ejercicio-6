BEGIN{cantLineas=0;
}
NF{
    cantLineas++;
}
END{
    print cantLineas;
}