contacts = (
	{"Имя": "Игорь", "Номер": "094-456-72-89"},
	{"Имя": "Виктор", "Номер": "092-664-52-88"},
	{"Имя": "Сергей", "Номер": "089-435-23-23"},
)

FORMAT_STR = '{:<15} {:>12}'

def list(contacts):
	print(FORMAT_STR.format("Имя", "Номер"))
	for contact in contacts:
		print(FORMAT_STR.format(
			contact ("Имя"),
			contact("Номер")
			))


def find(contacts):
	input (print("Введите имя контакта: "))

	for contact in contacts:
		if contact ("Имя") == Имя:
			print(FORMAT_STR.format(
			contact ("Имя"),
			contact("Номер")
			))
			break
		else:
			print("Контакт не найден")

def delete(contacts):
	input (print("Введите контакт: "))
	for contact in contacts:
		if contact ("Имя") == Имя:
			print("Вы действительно хотите удалить контакт? %s (Да/Нет)?: " %Имя)
			name_del = input("> ")
			if name_del == "Да":
				contacts.remove(contact)
				print("Контакт успешно удален!")

		def add(contacts):
			input (print("Введите имя контакта: "))
			input (print("Веедите номер телефона: "))
			new_contact = (
				"Имя",
				"Номер"
				)
			contact.append(new_contact)

			print("Контакт успешно сохранен!")

print("___Телефонная книга___")
print("""Что бы вы хотели?:
* Список (Выводит список контактов)
* Найти (Находит нужный контакт)
* Добавить (Добавляет новый контакт)
* Удалить (Удаляет выбранный контакт)
* Изменить (Изменяет выбранный контакт)
* Выход """)

while True:
    print("\nВведите команду: ")
    command = input('> ')
    if command == 'Список':
        list(contacts)
    elif command == 'Найти':
        find(contacts)
    elif command == 'Добавить':
        add(contacts)
    elif command == 'Удалить':
        delete(contacts)
    elif command == 'Изменить': 
        edit(contacts)       
    elif command == 'Выход':
        break
    else:
        print("Неизвестная команда. \n(Возможно введена команда с маленькой буквы)")