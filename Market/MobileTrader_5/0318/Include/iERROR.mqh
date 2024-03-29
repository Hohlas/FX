void ERROR_CHECK(string ErrTxt){ // Проверка проведения операций с ордерами. Возвращает необходимость повтора торговой операции
   int err=GetLastError(); //
   ResetLastError();
   if (err==0) return; // Ошибок нет. Повтор не нужен
   string ErrDescription;
   switch(err){
      case ERR_SUCCESS:                   ErrDescription="Операция выполнена успешно"; break;
      case ERR_INTERNAL_ERROR:            ErrDescription="Неожиданная внутренняя ошибка"; break;
      case ERR_WRONG_INTERNAL_PARAMETER:  ErrDescription="Ошибочный параметр при внутреннем вызове функции клиентского терминала"; break;
      case ERR_INVALID_PARAMETER:         ErrDescription="Ошибочный параметр при вызове системной функции"; break;
      case ERR_NOT_ENOUGH_MEMORY:         ErrDescription="Недостаточно памяти для выполнения системной функции"; break;
      case ERR_STRUCT_WITHOBJECTS_ORCLASS:ErrDescription="Структура содержит объекты строк и/или динамических массивов и/или структуры с такими объектами и/или классы"; break;
      case ERR_INVALID_ARRAY:             ErrDescription="Массив неподходящего типа, неподходящего размера или испорченный объект динамического массива"; break;
      case ERR_ARRAY_RESIZE_ERROR:        ErrDescription="Недостаточно памяти для перераспределения массива либо попытка изменения размера статического массива"; break;
      case ERR_STRING_RESIZE_ERROR:       ErrDescription="Недостаточно памяти для перераспределения строки"; break;
      case ERR_NOTINITIALIZED_STRING:     ErrDescription="Неинициализированная строка"; break;
      case ERR_INVALID_DATETIME:          ErrDescription="Неправильное значение даты и/или времени"; break;
      case ERR_ARRAY_BAD_SIZE:            ErrDescription="Общее число элементов в массиве не может превышать 2147483647"; break;
      case ERR_INVALID_POINTER:           ErrDescription="Ошибочный указатель"; break;
      case ERR_INVALID_POINTER_TYPE:      ErrDescription="Ошибочный тип указателя"; break;
      case ERR_FUNCTION_NOT_ALLOWED:      ErrDescription="Системная функция не разрешена для вызова"; break;
      case ERR_RESOURCE_NAME_DUPLICATED:  ErrDescription="Совпадение имени динамического и статического ресурсов"; break;
      case ERR_RESOURCE_NOT_FOUND:        ErrDescription="Ресурс с таким именем в EX5 не найден"; break;
      case ERR_RESOURCE_UNSUPPOTED_TYPE:  ErrDescription="Неподдерживаемый тип ресурса или размер более 16 MB"; break;
      case ERR_RESOURCE_NAME_IS_TOO_LONG: ErrDescription="Имя ресурса превышает 63 символа"; break;
      case ERR_MATH_OVERFLOW:             ErrDescription="При вычислении математической функции произошло переполнение "; break;
      // Графики
      case ERR_CHART_WRONG_ID:            ErrDescription="Ошибочный идентификатор графика"; break;
      case ERR_CHART_NO_REPLY:            ErrDescription="График не отвечает"; break;
      case ERR_CHART_NOT_FOUND:           ErrDescription="График не найден"; break;
      case ERR_CHART_NO_EXPERT:           ErrDescription="У графика нет эксперта, который мог бы обработать событие"; break;
      case ERR_CHART_CANNOT_OPEN:         ErrDescription="Ошибка открытия графика"; break;
      case ERR_CHART_CANNOT_CHANGE:       ErrDescription="Ошибка при изменении для графика символа и периода"; break;
      case ERR_CHART_WRONG_PARAMETER:     ErrDescription="Ошибочное значение параметра для функции по работе с графиком"; break;
      case ERR_CHART_CANNOT_CREATE_TIMER: ErrDescription="Ошибка при создании таймера"; break;
      case ERR_CHART_WRONG_PROPERTY:      ErrDescription="Ошибочный идентификатор свойства графика"; break;
      case ERR_CHART_SCREENSHOT_FAILED:   ErrDescription="Ошибка при создании скриншота"; break;
      case ERR_CHART_NAVIGATE_FAILED:     ErrDescription="Ошибка навигации по графику"; break;
      case ERR_CHART_TEMPLATE_FAILED:     ErrDescription="Ошибка при применении шаблона"; break;
      case ERR_CHART_WINDOW_NOT_FOUND:    ErrDescription="Подокно, содержащее указанный индикатор, не найдено"; break;
      case ERR_CHART_INDICATOR_CANNOT_ADD:ErrDescription="Ошибка при добавлении индикатора на график"; break;
      case ERR_CHART_INDICATOR_CANNOT_DEL:ErrDescription="Ошибка при удалении индикатора с графика"; break;
      case ERR_CHART_INDICATOR_NOT_FOUND: ErrDescription="Индикатор не найден на указанном графике"; break;
      // Графические объекты
      case ERR_OBJECT_ERROR:              ErrDescription="Ошибка при работе с графическим объектом"; break;
      case ERR_OBJECT_NOT_FOUND:          ErrDescription="Графический объект не найден"; break;
      case ERR_OBJECT_WRONG_PROPERTY:     ErrDescription="Ошибочный идентификатор свойства графического объекта"; break;
      case ERR_OBJECT_GETDATE_FAILED:     ErrDescription="Невозможно получить дату, соответствующую значению"; break;
      case ERR_OBJECT_GETVALUE_FAILED:    ErrDescription="Невозможно получить значение, соответствующее дате"; break;
      // MarketInfo
      case ERR_MARKET_UNKNOWN_SYMBOL:     ErrDescription="Неизвестный символ"; break;
      case ERR_MARKET_NOT_SELECTED:       ErrDescription="Символ не выбран в MarketWatch"; break;
      case ERR_MARKET_WRONG_PROPERTY:     ErrDescription="Ошибочный идентификатор свойства символа"; break;
      case ERR_MARKET_LASTTIME_UNKNOWN:   ErrDescription="Время последнего тика неизвестно (тиков не было)"; break;
      case ERR_MARKET_SELECT_ERROR:       ErrDescription="Ошибка добавления или удаления символа в MarketWatch"; break;
      // Доступ к истории
      //case 4014:  ErrDescription="Системная функция не разрешена для вызова"; break;
      //case 4401:  ErrDescription="Запрашиваемая история не найдена"; break;
      //case 4515:  ErrDescription="Не удалось отправить уведомление"; break;
      //case 4516:  ErrDescription="Неверный параметр для отправки уведомления "; break;
      //case 4517:  ErrDescription="Неверные настройки уведомлений в терминале (не указан ID или не выставлено разрешение)"; break;
      //case 4518:  ErrDescription="Слишком частая отправка уведомлений"; break;
      default:    ErrDescription="Some Error"; break;
      }
   ErrTxt="Ошибка №"+string(err)+" в функции "+ErrTxt+": "+ErrDescription;
   Alert(ErrTxt);  
   }	