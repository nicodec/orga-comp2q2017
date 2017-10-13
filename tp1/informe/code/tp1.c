#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <unistd.h>
#include <getopt.h>
#include <errno.h>
#include <string.h>

extern size_t mystrlen(const char*);
extern int palindrome(int, size_t, int, size_t);

/* imprimir el uso de tp0 */
void print_usage() {
    printf("Usage: tp0 -i [input_file] -o [output_file]\n");
}

/* imprimir la pagina de ayuda */
void print_help() {
    printf("\tUsage:\n"
    	"\t\ttp0 -h\n"
    	"\t\ttp0 -V\n"
    	"\t\ttp0 [options]\n"
    	"\tOptions:\n"
    	"\t\t-V, --version\tPrint version and quit.\n"
    	"\t\t-h, --help\tPrint this information.\n"
    	"\t\t-i, --input\tLocation of the input file.\n"
    	"\t\t-o, --output\tLocation of the output file.\n"
        "\t\t-I, --ibuf-bytes\tByte count of the input buffer.\n"
        "\t\t-O, --obuf-bytes\tByte count of the output buffer.\n"
    	"\tExamples:\n"
    	"\t\ttp0 -i ~/input -o ~/output\n");
}

/* imprimir la version del programa */
void print_version(){
    printf("tp1 1.0\n");
}

int main(int argc, char *argv[]) {

    int opt= 0;

    int help = -1;
    int version = -1;
    int input = -1;
    int output = -1;
    int ibuf = 1;
    int obuf = 1;

    char *input_filename = NULL;
    char *output_filename = NULL;

    // especificacion de las opciones
    static struct option long_options[] = {
        {"help",         no_argument,       0,  'h' },
        {"version",      no_argument,       0,  'V' },
        {"input",        required_argument, 0,  'i' },
        {"output",       required_argument, 0,  'o' },
        {"ibuf-bytes",   required_argument, 0,  'I' },
        {"obuf-bytes",   required_argument, 0,  'O' },
        {0,              0,                 0,  0   }
    };

    int long_index = 0;

    // evaluacion de los parametros enviados al programa
    while ((opt = getopt_long(argc, argv,"hVui:o:I:O:", 
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
            case 'I':
                ibuf = atoi(optarg);
                break;
            case 'O':
                obuf = atoi(optarg);
                break;
            case '?':
            	exit(1);
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
    char *msg = "Estoy probando mips!!!\n";
	write(1, msg, mystrlen(msg));

    int file_in = fileno(input_file);
    int file_out = fileno(output_file);

    printf("file_in: %i\nibuf: %zu\nfile_out: %i\nobuf: %zu\n",
            file_in,ibuf,file_out,obuf);

    
    int a = palindrome(file_in,ibuf,file_out,obuf);


    printf("a: %i\n",a);
    
    
    if (input == 0){
        fclose(input_file);
    }
    if (output == 0){
        fclose(output_file);
    }

    printf("sali bien\n");

    return 0;
}
