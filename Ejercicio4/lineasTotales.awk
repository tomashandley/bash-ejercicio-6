BEGIN{cantLineas=0;
}
$0 != ""{
    cantLineas++;
}
END{
    print cantLineas;
}