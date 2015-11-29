#include <windows.h> 

void DrawSerpinskiCover(HDC hdc, int x1,int y1,int x2,int y2, int x3,int y3 ,int n) {
	if (n > 0) {
		int x12, y12, x23, y23, x31, y31;
		x12 = (x1 + x2) / 2;
		x23 = (x2 + x3) / 2;
		x31 = (x3 + x1) / 2;
		y12 = (y1 + y2) / 2;
		y23 = (y2 + y3) / 2;
		y31 = (y3 + y1) / 2;
	    MoveToEx(hdc,x31,y31,NULL); 
		LineTo(hdc,x12,y12); 
        LineTo(hdc,x23,y23);
        LineTo(hdc,x31,y31);
		DrawSerpinskiCover(hdc,x1,y1,x12,y12,x31,y31, n-1);
		DrawSerpinskiCover(hdc,x2,y2,x12,y12,x23,y23, n-1);
		DrawSerpinskiCover(hdc, x3, y3, x31, y31, x23, y23, n - 1);
   }
}

LRESULT CALLBACK WndProc(HWND, UINT, WPARAM, LPARAM);
 
int WINAPI WinMain(HINSTANCE hInst,
                   HINSTANCE hPrevInst, 
                   LPSTR lpCmdLine, 
                   int nCmdShow) 
{
    TCHAR szClassName[] = L"My class"; 
    HWND hMainWnd;
    MSG msg; 
    WNDCLASSEX wc; 
	wc.cbSize        = sizeof(wc); 
    wc.style         = CS_HREDRAW | CS_VREDRAW; 
    wc.lpfnWndProc   = WndProc; 
    wc.lpszMenuName  = NULL; 
    wc.lpszClassName = szClassName; 
    wc.cbWndExtra    = NULL;
    wc.cbClsExtra    = NULL;
    wc.hIcon         = LoadIcon(NULL, IDI_WINLOGO);
    wc.hIconSm       = LoadIcon(NULL, IDI_WINLOGO);
    wc.hCursor       = LoadCursor(NULL, IDC_ARROW); 
    wc.hbrBackground = (HBRUSH)GetStockObject(WHITE_BRUSH); 
    wc.hInstance     = hInst; 
	if(!RegisterClassEx(&wc)){
        
        MessageBox(NULL, L"Cannot register class", L"Error", MB_OK);
        return NULL;
    } 
    hMainWnd = CreateWindow(
        szClassName, 
        L"Serpinski cover application",
        WS_OVERLAPPEDWINDOW ,
        CW_USEDEFAULT, 
        NULL,
        CW_USEDEFAULT, 
        NULL,
        NULL,
        NULL,
        hInst,
        NULL); 
   if(!hMainWnd){  
        MessageBox(NULL, L"Cannot create window!", L"Error!", MB_OK);
        return NULL;
   }   
   HWND ClearButton = CreateWindow(
	L"BUTTON", // predefined class 
	L"Clear", // button text 
	WS_VISIBLE | WS_CHILD | BS_DEFPUSHBUTTON, // styles
	10, // starting x position 
	10, // starting y position 
	50, // width 
	30, // height 
	hMainWnd, // parent window 
	(HMENU)777, // Name of event 
	(HINSTANCE)GetWindowLong(hMainWnd, GWL_HINSTANCE),
	NULL); // pointer not needed
    ShowWindow(hMainWnd, nCmdShow);
	UpdateWindow(hMainWnd); 
    while(GetMessage(&msg, NULL, NULL, NULL)){ // извлекаем сообщения из очереди, посылаемые фу-циями, ОС
        TranslateMessage(&msg); // интерпретируем сообщения
        DispatchMessage(&msg); // передаём сообщения обратно ОС
    }
    return msg.wParam; // возвращаем код выхода из приложения
}

LRESULT CALLBACK WndProc(HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam){
    // создаём дескриптор ориентации текста на экране
    PAINTSTRUCT ps; // структура, сод-щая информацию о клиентской области (размеры, цвет и тп)
	HDC hDC = GetDC(hWnd);
    RECT rect; // стр-ра, определяющая размер клиентской области
	HPEN hRandomPen;
    //COLORREF colorText = RGB(255, 0, 0); // задаём цвет текста
    switch(uMsg){
	case WM_COMMAND:
		if (LOWORD(wParam) == 777) {
			InvalidateRect(hWnd, NULL, true);
		}
		break;
    case WM_LBUTTONDOWN:
		WORD xPos, yPos, nSize;
		xPos   = LOWORD(lParam);
		yPos   = HIWORD(lParam);
		int x1, y1, x2, y2, x3, y3;
		x1 = xPos;
		y1 = yPos - 100;
		x2 = xPos - 100;
		y2 = yPos + 100;
		x3 = xPos + 100;
		y3 = y2;
		hRandomPen = CreatePen(PS_SOLID, 1, RGB(rand()%255, rand()%255, rand()%255));
		SelectObject(hDC, hRandomPen);
		DrawSerpinskiCover(hDC,x1,y1,x2,y2,x3,y3, 10);
        break;
    case WM_DESTROY: // если окошко закрылось, то:
        PostQuitMessage(NULL); // отправляем WinMain() сообщение WM_QUIT
        break;
    default:
        return DefWindowProc(hWnd, uMsg, wParam, lParam); // если закрыли окошко
    }
	return 0; // возвращаем значение
} 