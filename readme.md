## Три задачи на ассемблере:

#1. sequence.asm

Дан массив, который состоит из нулей и единиц. 
Выведите размер самой длинной непрерывной последовательности 
единиц в массиве.

Пример: `[0, 0, 1, 0, 1, 1, 1, 0]`

Ответ:  `3`

Пример: `[0, 0, 0]`

Ответ:  0

**Ограничения:**

- `0 < n < 50`, где `n` — длина массива
- массив состоит только из чисел `0` и `1`

#2. floors.asm

Вася бегает по этажам офисного здания с блокнотом в руках:

- когда он поднимается на 1 этаж, он записывает букву `u`
- когда он опускается  на 1 этаж, он записывает букву `d`

Определите по записям в блокноте (есть минимум 1 запись), смог ли Вася вернуться на исходный этаж в конце рабочего дня:

- выведите `1`, если Вася закончил работать там же, где начал
- выведите `0`, если Вася застрял на другом этаже

Пример: `['u', 'd', 'd', 'u', 'u', 'd', 'd', 'u']`

Ответ:  `1`

Пример: `['u', 'u', 'u']`

Ответ:  `0` (Вася закончил на 3 этажа выше)

#3. temperature.asm

Детям в школе задали на лето записывать каждый день:

- какая в этот день была температура
- если до этого были дни с более высокой температурой — записать температуру **ближайшего** такого дня (или -1, если таких дней не было)

Помогите Маше найти ближайшие предыдущие дни с более высокой температурой. 

ВАЖНО: решение должно выполняться за время O(n).

Пример: `[17, 21, 13, 17, 14, 12]`

Ответ:  `[-1, -1, 21, 21, 17, 14]`


**Ограничения:**

- `0 < n < 50`, где `n` — длина массива
- `0 < arr[i] < 50` для любого индекса `i` в массиве

Алгоритм решения:

Сначала заносим в стек -1, и выводим -1 на экран

(в первый день температура не может быть меньше, чем в предыдущий).

Начиная со 2-шо дня, проходим по массиву. 

Если сегодня температура меньше, чем была вчера,
заносим вчерашнюю температуру в стек + выводим её на экран.

Если сегодня температура не меньше, чем вчера, смотрим на последнее
число в стеке. Если оно -1, значит, стек пустой, т.е. раньше 
не было более теплых дней.

Если число в стеке положительно, сравниваем его с сегодняшним. 
Если оно больше сегодняшнего -> выводим его на экран.
Если меньше и не равно -1 -> выбрасываем из стека, и смотрим следующее.