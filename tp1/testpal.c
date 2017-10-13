int testpal(char * palabra, int len)
{
    if (len < 2) {
 		return true;
 	}

    char primero = tolower(palabra[0])
    char ultimo = tolower(palabra[len - 1])

    if (primero == ultimo)
 	{
 		return testpal(palabra + 1, len -2);
 	}
    
	return false;
}
