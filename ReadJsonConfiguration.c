#include "ReadJsonConfiguration.h"
#include "../json-c/include/json-c/json.h"


#define MAX_PATH_LENGTH 256

// Array to store SkipParameters
struct SkipParameters* paramsVector = NULL;
int vectorSize = 0;
#define TRUE 1
#define FALSE 0
#define bool int

static bool hasAlreadyReadLogFile = FALSE;

// Define a structure to represent skipParameters
struct SkipParameters 
{
    char* sourceIP;
    char* destinationIP;
    int destinationPort; // Use -1 if not present
};

char * strDuplicate(char* inputSting)
{
#ifdef _WIN32
    // Windows-specific code
    return _strdup(inputSting);
#else
    // Non-Windows (assume POSIX) code
    return strdup(inputSting);
#endif
}

/*--------------------------------------------------------------------------------------------------------------------------*/
static void getProgramFolderPath(char* buffer, size_t size) 
{
    // Get the folder path of the currently running program
    char* end;
    size_t length;

#ifdef _WIN32
    GetModuleFileName(NULL, buffer, size);
    end = strrchr(buffer, '\\');
#else
    if (readlink("/proc/self/exe", buffer, size) == -1) {
        perror("readlink");
        exit(EXIT_FAILURE);
    }
    end = strrchr(buffer, '/');
#endif

    if (end == NULL) {
        //fprintf(stderr, "Error: Unable to determine program folder path.\n");
        exit(EXIT_FAILURE);
    }

    length = (size_t)(end - buffer);
    buffer[length] = '\0';  // Null-terminate the string
}

/*--------------------------------------------------------------------------------------------------------------------------*/
static void appendFileNameToPath(const char* file_name, const char* folder_path, char* output_path, size_t size) 
{
    // Join the file name with the folder path
#ifdef _WIN32
    snprintf(output_path, size, "%s\\%s", folder_path, file_name);
#else
    snprintf(output_path, size, "%s/%s", folder_path, file_name);
#endif
}


/*--------------------------------------------------------------------------------------------------------------------------*/
// Function to traverse JSON and create an array of SkipParameters
static void traverseJsonObject(json_object* jsonObj, struct SkipParameters** paramsVector, int* vectorSize)
{
    json_object_object_foreach(jsonObj, key, val) {
        enum json_type type = json_object_get_type(val);

        if (type == json_type_object)
        {
            traverseJsonObject(val, paramsVector, vectorSize);
        }
        else if (type == json_type_array)
        {
            int arrayLength = json_object_array_length(val);
            int i = 0;
            for (i = 0; i < arrayLength; ++i)
            {
                *vectorSize += 1;
                *paramsVector = realloc(*paramsVector, (*vectorSize) * sizeof(struct SkipParameters));
                (*paramsVector)[*vectorSize - 1].sourceIP = strDuplicate("NOT_SET");
                (*paramsVector)[*vectorSize - 1].destinationIP = strDuplicate("NOT_SET");
                (*paramsVector)[*vectorSize - 1].destinationPort = -1;

                json_object* arrayElement = json_object_array_get_idx(val, i);
                traverseJsonObject(arrayElement, paramsVector, vectorSize);
            }
        }
        else
        {
            if (type == json_type_string)
            {
                // Assume string key, add your own logic if it's different
                const char* keyStr = key;
                const char* valueStr = json_object_get_string(val);

                // Check if key is one of the desired parameters
                if (strcmp(keyStr, "sourceIP") == 0)
                {
                    char* sourceIP = strDuplicate(valueStr);
                    (*paramsVector)[*vectorSize - 1].sourceIP = sourceIP;
                }

                // Check if key is one of the desired parameters
                if (strcmp(keyStr, "destinationIP") == 0)
                {
                    char* destinationIP = strDuplicate(valueStr);
                    (*paramsVector)[*vectorSize - 1].destinationIP = destinationIP;
                }

            }
            else if (type == json_type_int)
            {
                // Assume string key, add your own logic if it's different
                const char* keyStr = key;
                int destinationPort = json_object_get_int(val);

                (*paramsVector)[*vectorSize - 1].destinationPort = destinationPort;
            }
        }
    }
}

/*--------------------------------------------------------------------------------------------------------------------------*/
void FreeSettingsConfigurationData()
{
    // Free allocated memory
    int i = 0;
    for ( i = 0; i < vectorSize; ++i)
    {
        free(paramsVector[i].sourceIP);
        free(paramsVector[i].destinationIP);
    }

    free(paramsVector);
}

/*--------------------------------------------------------------------------------------------------------------------------*/
static bool matchEntryInParamsVector(const char* srcIP, const char* destIP, int destPort) 
{
    int i = 0;
    for (i = 0; i < vectorSize; ++i) 
    {
        // Check if sourceIP matches
        if (strcmp(paramsVector[i].sourceIP, "NOT_SET") != 0 && strcmp(paramsVector[i].sourceIP, srcIP) != 0) 
        {
            continue;
        }

        // Check if destinationIP matches
        if (strcmp(paramsVector[i].destinationIP, "NOT_SET") != 0 && strcmp(paramsVector[i].destinationIP, destIP) != 0) 
        {
            continue;
        }

        // Check if destinationPort matches (if present)
        if (paramsVector[i].destinationPort != -1 && paramsVector[i].destinationPort != destPort) 
        {
            continue;
        }

        // All criteria match, return true
        return TRUE;
    }

    // No matching entry found
    return FALSE;
}

/*--------------------------------------------------------------------------------------------------------------------------*/
static void printParamsVector(const struct SkipParameters* paramsVector, int vectorSize)
{
    printf("Params Vector:\n");

    int i = 0;
    for ( i = 0; i < vectorSize; ++i) {
        printf("Entry %d:\n", i + 1);
        printf("  Source IP: %s\n", paramsVector[i].sourceIP);
        printf("  Destination IP: %s\n", paramsVector[i].destinationIP);

        if (paramsVector[i].destinationPort != -1) 
        {
            printf("  Destination Port: %d\n", paramsVector[i].destinationPort);
        }
        else 
        {
            printf("  Destination Port: Not present\n");
        }

        printf("\n");
    }
}

/*--------------------------------------------------------------------------------------------------------------------------*/
 int IsValidFlowForLogging()
{
    return 1;
}