import Foundation

// MARK: - Localization Manager

struct Localization {
    let language: AppLanguage
    
    init(language: AppLanguage) {
        self.language = language
    }
    
    /// Get a localized string by key
    func t(_ key: String) -> String {
        return Self.strings[key]?[language] ?? Self.strings[key]?[.en] ?? key
    }
    
    // MARK: - String Dictionary
    
    static let strings: [String: [AppLanguage: String]] = [
        // App
        "app_name": [
            .zhHans: "LLM 余额监控", .zhHant: "LLM 餘額監控", .en: "LLM Balance Monitor",
            .es: "Monitor de Saldo API", .ja: "API残高モニター",
            .ko: "API 잔액 모니터", .th: "ตัวตรวจสอบยอดเงิน API", .ms: "Pemantau Baki API",
            .hi: "API बैलेंस मॉनिटर", .fr: "Moniteur de Solde API", .ar: "مراقب رصيد API",
            .ru: "Монитор Баланса API", .pt: "Monitor de Saldo API"
        ],
        "app_title": [
            .zhHans: "LLM 余额监控", .zhHant: "LLM 餘額監控", .en: "LLM Balance Monitor",
            .es: "Monitor de Saldo API", .ja: "API残高モニター",
            .ko: "API 잔액 모니터", .th: "ตัวตรวจสอบยอดเงิน API", .ms: "Pemantau Baki API",
            .hi: "API बैलेंस मॉनिटर", .fr: "Moniteur de Solde API", .ar: "مراقب رصيد API",
            .ru: "Монитор Баланса API", .pt: "Monitor de Saldo API"
        ],
        
        // Menu
        "refresh_all": [
            .zhHans: "立即刷新全部", .zhHant: "立即重新整理全部", .en: "Refresh All",
            .es: "Actualizar Todo", .ja: "すべて更新",
            .ko: "전체 새로고침", .th: "รีเฟรชทั้งหมด", .ms: "Segar Semula Semua",
            .hi: "सभी रिफ्रेश करें", .fr: "Tout Actualiser", .ar: "تحديث الكل",
            .ru: "Обновить Всё", .pt: "Atualizar Tudo"
        ],
        "settings": [
            .zhHans: "设置", .zhHant: "設定", .en: "Settings",
            .es: "Configuración", .ja: "設定",
            .ko: "설정", .th: "การตั้งค่า", .ms: "Tetapan",
            .hi: "सेटिंग्स", .fr: "Paramètres", .ar: "الإعدادات",
            .ru: "Настройки", .pt: "Configurações"
        ],
        "quit": [
            .zhHans: "退出 LLM Balance Monitor", .zhHant: "退出 LLM Balance Monitor",
            .en: "Quit LLM Balance Monitor", .es: "Salir de LLM Balance Monitor",
            .ja: "LLM Balance Monitorを終了", .ko: "LLM Balance Monitor 종료",
            .th: "ออกจาก LLM Balance Monitor", .ms: "Keluar LLM Balance Monitor",
            .hi: "LLM Balance Monitor से बाहर निकलें", .fr: "Quitter LLM Balance Monitor",
            .ar: "إنهاء LLM Balance Monitor", .ru: "Выйти из LLM Balance Monitor",
            .pt: "Sair do LLM Balance Monitor"
        ],
        "switch_to": [
            .zhHans: "切换", .zhHant: "切換", .en: "Switch",
            .es: "Cambiar", .ja: "切替",
            .ko: "전환", .th: "สลับ", .ms: "Tukar",
            .hi: "स्विच करें", .fr: "Basculer", .ar: "تبديل",
            .ru: "Переключить", .pt: "Alternar"
        ],
        "displaying": [
            .zhHans: "● 显示中", .zhHant: "● 顯示中", .en: "● Active",
            .es: "● Activo", .ja: "● 表示中",
            .ko: "● 표시 중", .th: "● กำลังแสดง", .ms: "● Aktif",
            .hi: "● सक्रिय", .fr: "● Actif", .ar: "● نشط",
            .ru: "● Активно", .pt: "● Ativo"
        ],
        "not_configured": [
            .zhHans: "未配置", .zhHant: "未配置", .en: "Not configured",
            .es: "No configurado", .ja: "未設定",
            .ko: "구성되지 않음", .th: "ไม่ได้กำหนดค่า", .ms: "Tidak dikonfigurasi",
            .hi: "कॉन्फ़िगर नहीं किया गया", .fr: "Non configuré", .ar: "غير مكوّن",
            .ru: "Не настроено", .pt: "Não configurado"
        ],
        "not_set": [
            .zhHans: "未设置", .zhHant: "未設定", .en: "Not set",
            .es: "No establecido", .ja: "未設定",
            .ko: "설정되지 않음", .th: "ไม่ได้ตั้งค่า", .ms: "Tidak ditetapkan",
            .hi: "सेट नहीं किया गया", .fr: "Non défini", .ar: "غير معيّن",
            .ru: "Не задано", .pt: "Não definido"
        ],
        "balance": [
            .zhHans: "余额", .zhHant: "餘額", .en: "Balance",
            .es: "Saldo", .ja: "残高",
            .ko: "잔액", .th: "ยอดเงิน", .ms: "Baki",
            .hi: "बैलेंस", .fr: "Solde", .ar: "الرصيد",
            .ru: "Баланс", .pt: "Saldo"
        ],
        "today": [
            .zhHans: "今日", .zhHant: "今日", .en: "Today",
            .es: "Hoy", .ja: "今日",
            .ko: "오늘", .th: "วันนี้", .ms: "Hari ini",
            .hi: "आज", .fr: "Aujourd'hui", .ar: "اليوم",
            .ru: "Сегодня", .pt: "Hoje"
        ],
        "sessions": [
            .zhHans: "会话", .zhHant: "會話", .en: "Sessions",
            .es: "Sesiones", .ja: "セッション",
            .ko: "세션", .th: "เซสชัน", .ms: "Sesi",
            .hi: "सत्र", .fr: "Sessions", .ar: "جلسات",
            .ru: "Сессии", .pt: "Sessões"
        ],
        "conversations": [
            .zhHans: "次对话", .zhHant: "次對話", .en: " conversations",
            .es: " conversaciones", .ja: "回の会話",
            .ko: "회 대화", .th: "การสนทนา", .ms: " perbualan",
            .hi: " बातचीत", .fr: " conversations", .ar: " محادثة",
            .ru: " диалогов", .pt: " conversas"
        ],
        "usage_today": [
            .zhHans: "今日用量", .zhHant: "今日用量", .en: "Today Usage",
            .es: "Uso de hoy", .ja: "本日の使用量",
            .ko: "오늘 사용량", .th: "การใช้งานวันนี้", .ms: "Penggunaan Hari Ini",
            .hi: "आज का उपयोग", .fr: "Utilisation du jour", .ar: "استخدام اليوم",
            .ru: "Использовано сегодня", .pt: "Uso de Hoje"
        ],
        "last_updated": [
            .zhHans: "更新", .zhHant: "更新", .en: "Updated",
            .es: "Actualizado", .ja: "更新",
            .ko: "업데이트", .th: "อัปเดต", .ms: "Dikemas kini",
            .hi: "अपडेट किया गया", .fr: "Mis à jour", .ar: "تم التحديث",
            .ru: "Обновлено", .pt: "Atualizado"
        ],
        
        // Settings Window
        "settings_title": [
            .zhHans: "LLM Balance Monitor 设置", .zhHant: "LLM Balance Monitor 設定",
            .en: "LLM Balance Monitor Settings", .es: "Configuración de LLM Balance Monitor",
            .ja: "LLM Balance Monitor 設定", .ko: "LLM Balance Monitor 설정",
            .th: "การตั้งค่า LLM Balance Monitor", .ms: "Tetapan LLM Balance Monitor",
            .hi: "LLM Balance Monitor सेटिंग्स", .fr: "Paramètres LLM Balance Monitor",
            .ar: "إعدادات LLM Balance Monitor", .ru: "Настройки LLM Balance Monitor",
            .pt: "Configurações do LLM Balance Monitor"
        ],
        "api_key_config": [
            .zhHans: "API Key 配置", .zhHant: "API Key 配置", .en: "API Key Configuration",
            .es: "Configuración de API Key", .ja: "APIキー設定",
            .ko: "API 키 구성", .th: "การกำหนดค่า API Key", .ms: "Konfigurasi Kunci API",
            .hi: "API की कॉन्फ़िगरेशन", .fr: "Configuration Clé API", .ar: "تكوين مفتاح API",
            .ru: "Конфигурация API Ключа", .pt: "Configuração da Chave API"
        ],
        "enter_api_key": [
            .zhHans: "输入 API Key...", .zhHant: "輸入 API Key...", .en: "Enter API Key...",
            .es: "Ingresar API Key...", .ja: "APIキーを入力...",
            .ko: "API 키 입력...", .th: "ป้อน API Key...", .ms: "Masukkan Kunci API...",
            .hi: "API की दर्ज करें...", .fr: "Saisir la Clé API...", .ar: "أدخل مفتاح API...",
            .ru: "Введите API Ключ...", .pt: "Inserir Chave API..."
        ],
        "no_config_needed": [
            .zhHans: "无需配置（自动读取本地数据）", .zhHant: "無需配置（自動讀取本地數據）",
            .en: "No config needed (reads local data)", .es: "Sin configuración (lee datos locales)",
            .ja: "設定不要（ローカルデータを自動読取）",
            .ko: "구성 불필요 (로컬 데이터 자동 읽기)", .th: "ไม่ต้องกำหนดค่า (อ่านข้อมูลในเครื่องอัตโนมัติ)",
            .ms: "Tiada konfigurasi diperlukan (baca data setempat)", .hi: "कॉन्फ़िगरेशन की आवश्यकता नहीं (स्थानीय डेटा पढ़ता है)",
            .fr: "Aucune configuration (lit les données locales)", .ar: "لا حاجة للتكوين (يقرأ البيانات المحلية)",
            .ru: "Настройка не требуется (читает локальные данные)", .pt: "Sem configuração (lê dados locais)"
        ],
        "show": [
            .zhHans: "显示", .zhHant: "顯示", .en: "Show",
            .es: "Mostrar", .ja: "表示",
            .ko: "표시", .th: "แสดง", .ms: "Tunjuk",
            .hi: "दिखाएं", .fr: "Afficher", .ar: "إظهار",
            .ru: "Показать", .pt: "Mostrar"
        ],
        "hide": [
            .zhHans: "隐藏", .zhHant: "隱藏", .en: "Hide",
            .es: "Ocultar", .ja: "非表示",
            .ko: "숨기기", .th: "ซ่อน", .ms: "Sembunyi",
            .hi: "छिपाएं", .fr: "Masquer", .ar: "إخفاء",
            .ru: "Скрыть", .pt: "Ocultar"
        ],
        "status_bar_display": [
            .zhHans: "状态栏显示:", .zhHant: "狀態欄顯示:", .en: "Status Bar:",
            .es: "Barra de estado:", .ja: "ステータスバー:",
            .ko: "상태 표시줄:", .th: "แถบสถานะ:", .ms: "Bar Status:",
            .hi: "स्टेटस बार:", .fr: "Barre d'état:", .ar: "شريط الحالة:",
            .ru: "Строка состояния:", .pt: "Barra de Status:"
        ],
        "refresh_interval": [
            .zhHans: "刷新间隔:", .zhHant: "重新整理間隔:", .en: "Refresh Interval:",
            .es: "Intervalo de actualización:", .ja: "更新間隔:",
            .ko: "새로고침 간격:", .th: "ช่วงเวลารีเฟรช:", .ms: "Selang Segar Semula:",
            .hi: "रिफ्रेश अंतराल:", .fr: "Intervalle d'actualisation:", .ar: "فترة التحديث:",
            .ru: "Интервал обновления:", .pt: "Intervalo de Atualização:"
        ],
        "language": [
            .zhHans: "语言:", .zhHant: "語言:", .en: "Language:",
            .es: "Idioma:", .ja: "言語:",
            .ko: "언어:", .th: "ภาษา:", .ms: "Bahasa:",
            .hi: "भाषा:", .fr: "Langue:", .ar: "اللغة:",
            .ru: "Язык:", .pt: "Idioma:"
        ],
        "launch_at_login": [
            .zhHans: "登录时自动启动", .zhHant: "登入時自動啟動",
            .en: "Launch at login", .es: "Iniciar al iniciar sesión",
            .ja: "ログイン時に起動",
            .ko: "로그인 시 시작", .th: "เปิดเมื่อเข้าสู่ระบบ",
            .ms: "Lancarkan semasa log masuk", .hi: "लॉगिन पर लॉन्च करें",
            .fr: "Lancer à l'ouverture de session", .ar: "تشغيل عند تسجيل الدخول",
            .ru: "Запускать при входе", .pt: "Iniciar ao fazer login"
        ],
        "save_settings": [
            .zhHans: "保存设置", .zhHant: "儲存設定", .en: "Save Settings",
            .es: "Guardar Configuración", .ja: "設定を保存",
            .ko: "설정 저장", .th: "บันทึกการตั้งค่า", .ms: "Simpan Tetapan",
            .hi: "सेटिंग्स सहेजें", .fr: "Enregistrer", .ar: "حفظ الإعدادات",
            .ru: "Сохранить", .pt: "Salvar Configurações"
        ],
        "settings_saved": [
            .zhHans: "设置已保存", .zhHant: "設定已儲存", .en: "Settings Saved",
            .es: "Configuración Guardada", .ja: "設定を保存しました",
            .ko: "설정이 저장되었습니다", .th: "บันทึกการตั้งค่าแล้ว", .ms: "Tetapan Disimpan",
            .hi: "सेटिंग्स सहेजी गईं", .fr: "Paramètres Enregistrés", .ar: "تم حفظ الإعدادات",
            .ru: "Настройки Сохранены", .pt: "Configurações Salvas"
        ],
        "settings_saved_msg": [
            .zhHans: "余额监控将立即刷新。在菜单栏切换显示服务商，点击菜单可查看全部。",
            .zhHant: "餘額監控將立即重新整理。在選單列切換顯示服務商，點選選單可檢視全部。",
            .en: "Balance monitoring will refresh immediately. Switch providers in the menu bar or view all in the menu.",
            .es: "El monitoreo de saldo se actualizará inmediatamente. Cambie de proveedor en la barra de menú o vea todo en el menú.",
            .ja: "残高監視はすぐに更新されます。メニューバーでプロバイダーを切り替えるか、メニューですべて表示できます。",
            .ko: "잔액 모니터링이 즉시 새로고침됩니다. 메뉴 막대에서 제공업체를 전환하거나 메뉴에서 모두 볼 수 있습니다.",
            .th: "การตรวจสอบยอดเงินจะรีเฟรชทันที สลับผู้ให้บริการในแถบเมนูหรือดูทั้งหมดในเมนู",
            .ms: "Pemantauan baki akan disegar semula serta-merta. Tukar pembekal di bar menu atau lihat semua dalam menu.",
            .hi: "बैलेंस मॉनिटरिंग तुरंत रिफ्रेश होगी। मेनू बार में प्रदाता बदलें या मेनू में सभी देखें।",
            .fr: "La surveillance du solde s'actualisera immédiatement. Changez de fournisseur dans la barre de menu ou consultez tout dans le menu.",
            .ar: "ستتم مراقبة الرصيد وتحديثها فوراً. قم بتبديل المزود في شريط القائمة أو عرض الكل في القائمة.",
            .ru: "Мониторинг баланса обновится немедленно. Переключайте провайдеров в строке меню или просматривайте все в меню.",
            .pt: "O monitoramento de saldo será atualizado imediatamente. Alterne os provedores na barra de menu ou veja todos no menu."
        ],
        "settings_ok": [
            .zhHans: "确定", .zhHant: "確定", .en: "OK",
            .es: "Aceptar", .ja: "OK",
            .ko: "확인", .th: "ตกลง", .ms: "OK",
            .hi: "ठीक है", .fr: "OK", .ar: "موافق",
            .ru: "ОК", .pt: "OK"
        ],
        "settings_info": [
            .zhHans: "CodeBuddy 无需 API Key，自动读取本地会话记录。状态栏显示选中服务商，菜单中可查看全部。",
            .zhHant: "CodeBuddy 無需 API Key，自動讀取本地會話記錄。狀態欄顯示選中服務商，選單中可檢視全部。",
            .en: "CodeBuddy needs no API Key, reads local session data. Status bar shows selected provider, menu shows all.",
            .es: "CodeBuddy no necesita API Key, lee datos locales. La barra muestra el proveedor seleccionado, el menú muestra todo.",
            .ja: "CodeBuddyはAPIキー不要、ローカルセッションデータを自動読取。ステータスバーに選択プロバイダー、メニューに全表示。",
            .ko: "CodeBuddy는 API 키가 필요 없으며 로컬 세션 데이터를 자동으로 읽습니다. 상태 표시줄에 선택한 제공업체, 메뉴에 전체 표시.",
            .th: "CodeBuddy ไม่ต้องใช้ API Key อ่านข้อมูลเซสชันในเครื่องอัตโนมัติ แถบสถานะแสดงผู้ให้บริการที่เลือก เมนูแสดงทั้งหมด",
            .ms: "CodeBuddy tidak memerlukan Kunci API, membaca data sesi setempat. Bar status menunjukkan pembekal dipilih, menu menunjukkan semua.",
            .hi: "CodeBuddy को API की की आवश्यकता नहीं है, स्थानीय सत्र डेटा पढ़ता है। स्टेटस बार चयनित प्रदाता दिखाता है, मेनू सभी दिखाता है।",
            .fr: "CodeBuddy n'a pas besoin de clé API, lit les données de session locales. La barre d'état montre le fournisseur sélectionné, le menu montre tout.",
            .ar: "CodeBuddy لا يحتاج إلى مفتاح API، يقرأ بيانات الجلسة المحلية. شريط الحالة يعرض المزود المحدد، القائمة تعرض الكل.",
            .ru: "CodeBuddy не требует API ключа, читает локальные данные сессий. Строка состояния показывает выбранного провайдера, меню показывает всех.",
            .pt: "CodeBuddy não precisa de Chave API, lê dados de sessão locais. Barra de status mostra o provedor selecionado, menu mostra todos."
        ],
        
        // Categories
        "category_domestic": [
            .zhHans: "中国厂商", .zhHant: "中國廠商", .en: "China",
            .es: "China", .ja: "中国",
            .ko: "중국", .th: "จีน", .ms: "China",
            .hi: "चीन", .fr: "Chine", .ar: "الصين",
            .ru: "Китай", .pt: "China"
        ],
        "category_international": [
            .zhHans: "国际厂商", .zhHant: "國際廠商", .en: "International",
            .es: "Internacional", .ja: "海外",
            .ko: "해외", .th: "นานาชาติ", .ms: "Antarabangsa",
            .hi: "अंतर्राष्ट्रीय", .fr: "International", .ar: "دولي",
            .ru: "Международные", .pt: "Internacional"
        ],
        
        // Service Names
        "qwen_name": [
            .zhHans: "通义千问", .zhHant: "通義千問", .en: "Qwen (Alibaba)",
            .es: "Qwen (Alibaba)", .ja: "Qwen (Alibaba)",
            .ko: "Qwen (Alibaba)", .th: "Qwen (Alibaba)", .ms: "Qwen (Alibaba)",
            .hi: "Qwen (Alibaba)", .fr: "Qwen (Alibaba)", .ar: "Qwen (Alibaba)",
            .ru: "Qwen (Alibaba)", .pt: "Qwen (Alibaba)"
        ],
        "zhipu_name": [
            .zhHans: "智谱 GLM", .zhHant: "智譜 GLM", .en: "ZhiPu GLM",
            .es: "ZhiPu GLM", .ja: "ZhiPu GLM",
            .ko: "ZhiPu GLM", .th: "ZhiPu GLM", .ms: "ZhiPu GLM",
            .hi: "ZhiPu GLM", .fr: "ZhiPu GLM", .ar: "ZhiPu GLM",
            .ru: "ZhiPu GLM", .pt: "ZhiPu GLM"
        ],
        "baidu_name": [
            .zhHans: "百度文心", .zhHant: "百度文心", .en: "Baidu ERNIE",
            .es: "Baidu ERNIE", .ja: "Baidu ERNIE",
            .ko: "Baidu ERNIE", .th: "Baidu ERNIE", .ms: "Baidu ERNIE",
            .hi: "Baidu ERNIE", .fr: "Baidu ERNIE", .ar: "Baidu ERNIE",
            .ru: "Baidu ERNIE", .pt: "Baidu ERNIE"
        ],
        "google_name": [
            .zhHans: "Google Gemini", .zhHant: "Google Gemini", .en: "Google Gemini",
            .es: "Google Gemini", .ja: "Google Gemini",
            .ko: "Google Gemini", .th: "Google Gemini", .ms: "Google Gemini",
            .hi: "Google Gemini", .fr: "Google Gemini", .ar: "Google Gemini",
            .ru: "Google Gemini", .pt: "Google Gemini"
        ],
        "together_name": [
            .zhHans: "Together AI", .zhHant: "Together AI", .en: "Together AI",
            .es: "Together AI", .ja: "Together AI",
            .ko: "Together AI", .th: "Together AI", .ms: "Together AI",
            .hi: "Together AI", .fr: "Together AI", .ar: "Together AI",
            .ru: "Together AI", .pt: "Together AI"
        ],
        "xai_name": [
            .zhHans: "xAI Grok", .zhHant: "xAI Grok", .en: "xAI Grok",
            .es: "xAI Grok", .ja: "xAI Grok",
            .ko: "xAI Grok", .th: "xAI Grok", .ms: "xAI Grok",
            .hi: "xAI Grok", .fr: "xAI Grok", .ar: "xAI Grok",
            .ru: "xAI Grok", .pt: "xAI Grok"
        ],
        "minimax_name": [
            .zhHans: "MiniMax", .zhHant: "MiniMax", .en: "MiniMax",
            .es: "MiniMax", .ja: "MiniMax",
            .ko: "MiniMax", .th: "MiniMax", .ms: "MiniMax",
            .hi: "MiniMax", .fr: "MiniMax", .ar: "MiniMax",
            .ru: "MiniMax", .pt: "MiniMax"
        ],
        "seed_name": [
            .zhHans: "豆包 Seed（字节）", .zhHant: "豆包 Seed（字節）", .en: "Doubao Seed (ByteDance)",
            .es: "Doubao Seed (ByteDance)", .ja: "豆包 Seed (ByteDance)",
            .ko: "Doubao Seed (ByteDance)", .th: "Doubao Seed (ByteDance)", .ms: "Doubao Seed (ByteDance)",
            .hi: "Doubao Seed (ByteDance)", .fr: "Doubao Seed (ByteDance)", .ar: "Doubao Seed (ByteDance)",
            .ru: "Doubao Seed (ByteDance)", .pt: "Doubao Seed (ByteDance)"
        ],
        
        // Error Messages
        "error_no_key": [
            .zhHans: "未设置 API Key", .zhHant: "未設定 API Key", .en: "API Key not set",
            .es: "API Key no configurada", .ja: "APIキー未設定",
            .ko: "API 키가 설정되지 않음", .th: "ไม่ได้ตั้งค่า API Key", .ms: "Kunci API tidak ditetapkan",
            .hi: "API की सेट नहीं है", .fr: "Clé API non définie", .ar: "مفتاح API غير معيّن",
            .ru: "API ключ не задан", .pt: "Chave API não definida"
        ],
        "error_url": [
            .zhHans: "URL 错误", .zhHant: "URL 錯誤", .en: "URL Error",
            .es: "Error de URL", .ja: "URLエラー",
            .ko: "URL 오류", .th: "ข้อผิดพลาด URL", .ms: "Ralat URL",
            .hi: "URL त्रुटि", .fr: "Erreur URL", .ar: "خطأ في الرابط",
            .ru: "Ошибка URL", .pt: "Erro de URL"
        ],
        "error_parse": [
            .zhHans: "无法解析数据", .zhHant: "無法解析數據", .en: "Cannot parse data",
            .es: "No se pueden analizar los datos", .ja: "データを解析できません",
            .ko: "데이터를 구문 분석할 수 없습니다", .th: "ไม่สามารถแยกวิเคราะห์ข้อมูลได้", .ms: "Tidak dapat menghurai data",
            .hi: "डेटा पार्स नहीं कर सकते", .fr: "Impossible d'analyser les données", .ar: "لا يمكن تحليل البيانات",
            .ru: "Не удалось разобрать данные", .pt: "Não foi possível analisar os dados"
        ],
        "error_timeout": [
            .zhHans: "请求超时", .zhHant: "請求超時", .en: "Request timeout",
            .es: "Tiempo de espera agotado", .ja: "リクエストタイムアウト",
            .ko: "요청 시간 초과", .th: "คำขอหมดเวลา", .ms: "Permintaan tamat masa",
            .hi: "अनुरोध का समय समाप्त", .fr: "Délai de requête dépassé", .ar: "انتهت مهلة الطلب",
            .ru: "Таймаут запроса", .pt: "Tempo limite da solicitação"
        ],
        "error_auth": [
            .zhHans: "认证失败", .zhHant: "認證失敗", .en: "Authentication failed",
            .es: "Autenticación fallida", .ja: "認証失敗",
            .ko: "인증 실패", .th: "การรับรองความถูกต้องล้มเหลว", .ms: "Pengesahan gagal",
            .hi: "प्रमाणीकरण विफल", .fr: "Échec d'authentification", .ar: "فشل المصادقة",
            .ru: "Ошибка аутентификации", .pt: "Falha na autenticação"
        ],
        "error_no_cookie": [
            .zhHans: "请设置 MiMo Cookie", .zhHant: "請設定 MiMo Cookie", .en: "Please set MiMo Cookie",
            .es: "Configure la Cookie de MiMo", .ja: "MiMoクッキーを設定してください",
            .ko: "MiMo 쿠키를 설정하세요", .th: "โปรดตั้งค่า MiMo Cookie", .ms: "Sila tetapkan Kuki MiMo",
            .hi: "कृपया MiMo कुकी सेट करें", .fr: "Veuillez configurer le cookie MiMo", .ar: "يرجى تعيين كوكيز MiMo",
            .ru: "Пожалуйста, задайте Cookie MiMo", .pt: "Por favor, defina o Cookie MiMo"
        ],
        "error_admin_key": [
            .zhHans: "需要 Admin API Key (sk-ant-admin 开头)", .zhHant: "需要 Admin API Key (sk-ant-admin 開頭)",
            .en: "Requires Admin API Key (starts with sk-ant-admin)", .es: "Requiere Admin API Key (comienza con sk-ant-admin)",
            .ja: "Admin APIキーが必要です（sk-ant-admin で始まる）",
            .ko: "Admin API 키가 필요합니다 (sk-ant-admin으로 시작)", .th: "ต้องใช้ Admin API Key (ขึ้นต้นด้วย sk-ant-admin)",
            .ms: "Memerlukan Kunci API Admin (bermula dengan sk-ant-admin)", .hi: "एडमिन API की आवश्यकता है (sk-ant-admin से शुरू)",
            .fr: "Nécessite une clé API Admin (commence par sk-ant-admin)", .ar: "يتطلب مفتاح API إداري (يبدأ بـ sk-ant-admin)",
            .ru: "Требуется Admin API ключ (начинается с sk-ant-admin)", .pt: "Requer Chave API Admin (começa com sk-ant-admin)"
        ],
        
        // Intervals
        "interval_30s": [
            .zhHans: "30 秒", .zhHant: "30 秒", .en: "30 sec", .es: "30 seg", .ja: "30秒",
            .ko: "30초", .th: "30 วินาที", .ms: "30 saat",
            .hi: "30 सेकंड", .fr: "30 s", .ar: "30 ثانية",
            .ru: "30 сек", .pt: "30 seg"
        ],
        "interval_1m": [
            .zhHans: "1 分钟", .zhHant: "1 分鐘", .en: "1 min", .es: "1 min", .ja: "1分",
            .ko: "1분", .th: "1 นาที", .ms: "1 min",
            .hi: "1 मिनट", .fr: "1 min", .ar: "1 دقيقة",
            .ru: "1 мин", .pt: "1 min"
        ],
        "interval_5m": [
            .zhHans: "5 分钟", .zhHant: "5 分鐘", .en: "5 min", .es: "5 min", .ja: "5分",
            .ko: "5분", .th: "5 นาที", .ms: "5 min",
            .hi: "5 मिनट", .fr: "5 min", .ar: "5 دقائق",
            .ru: "5 мин", .pt: "5 min"
        ],
        "interval_10m": [
            .zhHans: "10 分钟", .zhHant: "10 分鐘", .en: "10 min", .es: "10 min", .ja: "10分",
            .ko: "10분", .th: "10 นาที", .ms: "10 min",
            .hi: "10 मिनट", .fr: "10 min", .ar: "10 دقائق",
            .ru: "10 мин", .pt: "10 min"
        ],
        "interval_30m": [
            .zhHans: "30 分钟", .zhHant: "30 分鐘", .en: "30 min", .es: "30 min", .ja: "30分",
            .ko: "30분", .th: "30 นาที", .ms: "30 min",
            .hi: "30 मिनट", .fr: "30 min", .ar: "30 دقيقة",
            .ru: "30 мин", .pt: "30 min"
        ],
        "interval_1h": [
            .zhHans: "1 小时", .zhHant: "1 小時", .en: "1 hour", .es: "1 hora", .ja: "1時間",
            .ko: "1시간", .th: "1 ชั่วโมง", .ms: "1 jam",
            .hi: "1 घंटा", .fr: "1 heure", .ar: "1 ساعة",
            .ru: "1 час", .pt: "1 hora"
        ],
        
        // First Launch Welcome
        "welcome_title": [
            .zhHans: "欢迎使用 LLM 余额监控", .zhHant: "歡迎使用 LLM 餘額監控", .en: "Welcome to LLM Balance Monitor",
            .es: "Bienvenido a LLM Balance Monitor", .ja: "LLM Balance Monitorへようこそ",
            .ko: "LLM Balance Monitor에 오신 것을 환영합니다", .th: "ยินดีต้อนรับสู่ LLM Balance Monitor",
            .ms: "Selamat datang ke LLM Balance Monitor", .hi: "LLM Balance Monitor में आपका स्वागत है",
            .fr: "Bienvenue sur LLM Balance Monitor", .ar: "مرحباً بك في LLM Balance Monitor",
            .ru: "Добро пожаловать в LLM Balance Monitor", .pt: "Bem-vindo ao LLM Balance Monitor"
        ],
        "welcome_message": [
            .zhHans: "看起来你是第一次使用！\n\n要开始监控 LLM API 余额，请先配置至少一个服务商的 API Key。\n\n点击「立即设置」打开设置窗口，输入你的 API Key 即可开始使用。",
            .zhHant: "看起來你是第一次使用！\n\n要開始監控 LLM API 餘額，請先配置至少一個服務商的 API Key。\n\n點擊「立即設定」開啟設定視窗，輸入你的 API Key 即可開始使用。",
            .en: "Looks like this is your first time!\n\nTo start monitoring LLM API balances, please configure at least one API Key.\n\nClick \"Setup Now\" to open settings and enter your API Keys.",
            .es: "¡Parece que es tu primera vez!\n\nPara empezar a monitorizar los saldos de API, configura al menos una clave API.\n\nHaz clic en \"Configurar ahora\" para abrir los ajustes e introducir tus claves.",
            .ja: "初めてのご利用ですね！\n\nLLM APIの残高監視を始めるには、少なくとも1つのAPIキーを設定してください。\n\n「今すぐ設定」をクリックして設定画面を開き、APIキーを入力してください。",
            .ko: "처음 사용하시는 것 같습니다!\n\nLLM API 잔액 모니터링을 시작하려면 최소 하나의 API 키를 구성하세요.\n\n\"지금 설정\"을 클릭하여 설정 창을 열고 API 키를 입력하세요.",
            .th: "ดูเหมือนว่านี่เป็นครั้งแรกของคุณ!\n\nในการเริ่มตรวจสอบยอดเงิน LLM API โปรดกำหนดค่า API Key อย่างน้อยหนึ่งรายการ\n\nคลิก \"ตั้งค่าทันที\" เพื่อเปิดการตั้งค่าและป้อน API Key ของคุณ",
            .ms: "Nampaknya ini kali pertama anda!\n\nUntuk mula memantau baki LLM API, sila konfigurasikan sekurang-kurangnya satu Kunci API.\n\nKlik \"Sediakan Sekarang\" untuk membuka tetapan dan masukkan Kunci API anda.",
            .hi: "ऐसा लगता है कि यह आपका पहली बार है!\n\nLLM API बैलेंस मॉनिटरिंग शुरू करने के लिए, कृपया कम से कम एक API की कॉन्फ़िगर करें।\n\nसेटिंग्स खोलने और अपनी API की दर्ज करने के लिए \"अभी सेटअप करें\" पर क्लिक करें।",
            .fr: "On dirait que c'est votre première fois !\n\nPour commencer à surveiller les soldes API, veuillez configurer au moins une clé API.\n\nCliquez sur \"Configurer maintenant\" pour ouvrir les paramètres et saisir vos clés API.",
            .ar: "يبدو أن هذه هي المرة الأولى لك!\n\nلبدء مراقبة أرصدة API، يرجى تكوين مفتاح API واحد على الأقل.\n\nانقر على \"الإعداد الآن\" لفتح الإعدادات وإدخال مفاتيح API الخاصة بك.",
            .ru: "Похоже, вы здесь впервые!\n\nЧтобы начать мониторинг балансов API, настройте хотя бы один API ключ.\n\nНажмите «Настроить сейчас», чтобы открыть настройки и ввести ваши API ключи.",
            .pt: "Parece que é a sua primeira vez!\n\nPara começar a monitorizar os saldos de API, configure pelo menos uma Chave API.\n\nClique em \"Configurar Agora\" para abrir as definições e inserir as suas Chaves API."
        ],
        "welcome_setup": [
            .zhHans: "立即设置", .zhHant: "立即設定", .en: "Setup Now",
            .es: "Configurar ahora", .ja: "今すぐ設定",
            .ko: "지금 설정", .th: "ตั้งค่าทันที", .ms: "Sediakan Sekarang",
            .hi: "अभी सेटअप करें", .fr: "Configurer maintenant", .ar: "الإعداد الآن",
            .ru: "Настроить сейчас", .pt: "Configurar Agora"
        ],
        "welcome_later": [
            .zhHans: "稍后再说", .zhHant: "稍後再說", .en: "Later",
            .es: "Más tarde", .ja: "後で",
            .ko: "나중에", .th: "ภายหลัง", .ms: "Kemudian",
            .hi: "बाद में", .fr: "Plus tard", .ar: "لاحقاً",
            .ru: "Позже", .pt: "Mais tarde"
        ],
        "no_services_hint": [
            .zhHans: "尚未配置任何服务商，请打开设置添加 API Key", .zhHant: "尚未配置任何服務商，請開啟設定新增 API Key",
            .en: "No services configured yet. Open Settings to add an API Key.",
            .es: "Aún no hay servicios configurados. Abra Configuración para añadir una API Key.",
            .ja: "まだサービスが設定されていません。設定を開いてAPIキーを追加してください。",
            .ko: "아직 구성된 서비스가 없습니다. 설정을 열어 API 키를 추가하세요.",
            .th: "ยังไม่ได้กำหนดค่าบริการใด ๆ เปิดการตั้งค่าเพื่อเพิ่ม API Key",
            .ms: "Tiada perkhidmatan dikonfigurasikan lagi. Buka Tetapan untuk menambah Kunci API.",
            .hi: "अभी तक कोई सेवा कॉन्फ़िगर नहीं की गई है। API की जोड़ने के लिए सेटिंग्स खोलें।",
            .fr: "Aucun service configuré. Ouvrez les Paramètres pour ajouter une clé API.",
            .ar: "لم يتم تكوين أي خدمات بعد. افتح الإعدادات لإضافة مفتاح API.",
            .ru: "Сервисы ещё не настроены. Откройте Настройки, чтобы добавить API ключ.",
            .pt: "Nenhum serviço configurado ainda. Abra as Definições para adicionar uma Chave API."
        ],
        "get_api_key": [
            .zhHans: "获取 API Key", .zhHant: "獲取 API Key", .en: "Get API Key",
            .es: "Obtener API Key", .ja: "APIキーを取得",
            .ko: "API 키 받기", .th: "รับ API Key", .ms: "Dapatkan Kunci API",
            .hi: "API की प्राप्त करें", .fr: "Obtenir la Clé API", .ar: "الحصول على مفتاح API",
            .ru: "Получить API Ключ", .pt: "Obter Chave API"
        ],
    ]
}
