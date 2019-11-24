contacts = [
    {"Имя": "Игорь", "Номер": "025-338-46-88"},
    {"Имя": "Сергей", "Номер": "035-556-47-23"},
    {"Имя": "Констан", "Номер": "034-555-23-95"},
]

FORMAT_STR = '{:<15} {:>12}'
 
 
def list(contacts):
    print(FORMAT_STR.format('Имя', 'Номер'))
    for contact in contacts:
        print(FORMAT_STR.format(
            contact['Имя'],
            contact['Номер']
        ))
 
 
 
def find(contacts):
    print("Введите имя контакта:")
    name = input("> ")
 
    for contact in contacts:
        if contact['name'] == name:
            print(FORMAT_STR.format(
                contact['name'],
                contact['phone']
            ))
            break
    else: 
        print("Контакт не найден")
 
def delete(contacts):
    print("Введите контакт: ")
    name = input('> ')
    for contact in contacts:
        if contact['name'] == name:
            print("Вы хотите удалить контакт %s (Д/Н)?: " % name )
            name_del = input('> ')
            if name_del == 'Д':
               contacts.remove(contact)
               print("Вы удалили контакт %s " % name)
 
 
 
def add(contacts):
    print("Введите имя контакта:")
    name = input("> ")
    print("Введите телефон контакта:")
    phone = input("> ")
    new_contact = {
        'name': name,
        'phone': phone
    }
    contacts.append(new_contact)
    
    print('Контакт сохранён')
 
print("Добро пожаловать в телефонную книгу.")
print("""Что бы вы хотели?:
* Список (Выводит список контактов)
* Найти (Находит нужный контакт)
* Добавить (Добавляет новый контакт)
* Удалить (Удаляет выбранный контакт)
* Изменить (Изменяет выбранный контакт)
* Выход """)
 
while True:
    print("\nВыберите из списка: ")
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