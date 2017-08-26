#include <stdio.h>
#include <stdlib.h>

#include <ctype.h>
#include <unistd.h>
#include <getopt.h>
#include <errno.h>

/* imprimir el uso de tp0 */
void print_usage() {
    printf("Usage: tp0 -i [input_file] -o [output_file]\n");
}

/* imprimir la pagina de ayuda */
void print_help() {
    printf("This is the help message\n");
}

/* imprimir la version del programa */
void print_version(){
    printf("tp0 1.0\n");
}

/* funcion para determinar si una palabra es capicua o no */
int es_capicua(char *palabra){
    if (palabra[0] > 96){
        return 1;
    }
    return 0;
}

int read_word (FILE *f, char *word) {
    return fscanf(f, " %1023s", word);
}

int main(int argc, char *argv[]) {

    int opt= 0;

    int help = -1;
    int version = -1;
    int input = -1;
    int output =-1;

    char *input_filename = NULL;
    char *output_filename = NULL;

    // especificacion de las opciones
    static struct option long_options[] = {
        {"help",     no_argument,       0,  'h' },
        {"version",  no_argument,       0,  'V' },
        {"input",    required_argument, 0,  'i' },
        {"output",   required_argument, 0,  'o' },
        {0,          0,                 0,  0   }
    };

    int long_index = 0;

    // evaluacion de los parametros enviados al programa
    while ((opt = getopt_long(argc, argv,"hVui:o:", 
                   long_options, &long_index )) != -1) {
        switch (opt) {
            case 'h' :
                help = 0;
                break;
            case 'V' :
                version = 0;
                break;
            case 'i' :
                input = 0;
                input_filename = optarg; 
                break;
            case 'o' :
                output = 0;
                output_filename = optarg;
                break;
            default:
                print_usage(); 
                exit(EXIT_FAILURE);
        }
    }

    // procesamiento de los parametros
    if (help == 0) {
        print_help();
        exit(0);
    }
    else if (version == 0) {
        print_version();
        exit(0);
    }

    /* Si no se recibe parametro de ayuda o version se ejecuta el programa */ 
    // a modo de debug... 
    printf("archivo entrada: %s\n", input_filename);
    printf("archivo salida: %s\n", output_filename);

    // estableciendo los archivos de entrada y salida
    FILE *input_file = stdin;
    FILE *output_file = stdout;
    
    if (input == 0){
        input_file = fopen(input_filename,"r");
        if (input_file == NULL) {
            printf ("can't open input file, errno = %d\n", errno);
            return 1;
        }
    }
    if (output == 0){
        output_file = fopen(output_filename,"w");
        if (output_file == NULL) {
            printf ("Can't open output file, errno = %d\n", errno);
            return 1;
        }
    }

    /* ejecucion del programa */
    int i = 1;
    while (i == 1){
        char word[1024];
        i = read_word(input_file, word);
        if (es_capicua(word)){
            printf("Capicua\n");
        }
        else {
            printf("No es capicua\n");
        }
    }


    // cierro los archivos
    
    if (input == 0){
        fclose(input_file);
    }
    if (output == 0){
        fclose(output_file);
    }

    return 0;
}
