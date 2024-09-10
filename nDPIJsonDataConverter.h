#ifdef __cplusplus
extern "C" {
#endif

void ConvertnDPIDataFormat(char* jsonStr, char** converted_json_str, int* createAlert,  unsigned long long int* flow_id, unsigned int* flow_event_id, unsigned int* packet_id);
void DeletenDPIRisk(char* jsonStr, char** converted_json_str);
int CheckSRCIPField(const char * json_str);
char* UpdateXferIfGreater(char * json_str1, const char * json_str2);

#ifdef __cplusplus
}
#endif