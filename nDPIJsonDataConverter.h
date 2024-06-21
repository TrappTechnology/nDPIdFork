#ifdef __cplusplus
extern "C" {
#endif

void ConvertnDPIDataFormat(char* jsonStr, char** converted_json_str, int* createAlert,  unsigned long long int* flow_id);
void DeletenDPIRisk(char* jsonStr, char** converted_json_str);
int CheckSRCIPField(const char * json_str);

#ifdef __cplusplus
}
#endif