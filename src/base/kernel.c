extern int main(){
    const char *s = "Hello World";
    char * base = (char *)0xb8000;
    while (*s) {
        *base++ = *s++;
        *base++ = 0x0f;
    }
    return 1;
}
