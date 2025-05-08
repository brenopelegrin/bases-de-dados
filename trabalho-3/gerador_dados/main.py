from faker import Faker
import random
import os
import json
import shutil
from datetime import datetime, timedelta

fake = Faker("pt_BR")
NUMBER_OF_REPETITIONS = 15

def random_timedelta():
    day = random.randint(0, 364)
    hour = random.randint(0, 23)
    minute = random.randint(1, 59)
    second = random.randint(1, 59)
    
    dt = timedelta(days=day, hours=hour, minutes=minute, seconds=second)
    return dt
    

# Helper to generate timestamp strings
def random_timestamp(base=datetime(2025, 2, 1), offset_days=0, hour=0, minute=0):
    second = 0
    offset_days = (offset_days + random.randint(10, 365)) % 364
    hour = (hour + random.randint(1, 24)) % 23
    minute = (minute + random.randint(0, 60)) % 59
    second = random.randint(0, 59)
    
    dt = base + timedelta(days=offset_days)
    dt = dt.replace(hour=hour, minute=minute, second=second)
    return dt

def generate_conta_bancaria():
    return [
        {
            "numero_conta": str(random.randint(10000000000, 99999999999)),
            "agencia": str(random.randint(10000000, 99999999)),
            "tipo_conta": random.choice(["Corrente", "Poupança"])
        }
        for _ in range(NUMBER_OF_REPETITIONS)
    ]

def generate_localizacao():
    return [
        {
            "cep": fake.postcode().replace("-", "")[:8],
            "cidade": fake.city(),
            "estado": fake.estado_sigla(),
            "pais": "Brasil",
            "bairro": fake.bairro()
        }
        for _ in range(NUMBER_OF_REPETITIONS)
    ]

def generate_usuario(contas, localizacoes):
    nomes = set()
    while len(nomes) < NUMBER_OF_REPETITIONS:
        nomes.add(fake.first_name())
        
    sobrenomes = set()
    while len(sobrenomes) < NUMBER_OF_REPETITIONS:
        sobrenomes.add(fake.last_name())
        
    nomes, sobrenomes = list(nomes), list(sobrenomes)
    
    tipo = ['Locador', 'Locatario']
        
    return [
        {
            "CPF": fake.cpf().replace("-", "").replace(".", ""),
            "conta_bancaria": random.choice(contas)["numero_conta"],
            "id_localizacao": i + 1,
            "nome": nomes[i],
            "sobrenome": sobrenomes[i],
            "tipo": tipo[i % 2],
            "data_nascimento": str(fake.date_of_birth(minimum_age=18, maximum_age=80)),
            "sexo": random.choice(["M", "F"]),
            "telefone": f"9{random.randint(100000000, 999999999)}",
            "email": fake.email(),
            "senha": fake.password(length=12)
        }
        for i in range(NUMBER_OF_REPETITIONS)
    ]

def generate_propriedade():
    lista = []
    for k in range(NUMBER_OF_REPETITIONS):
        horario_entrada = random_timestamp(offset_days=0, hour=0, minute= 0)
        dicionario = {
            "id_localizacao": k + 1,
            "nome": fake.company(),
            "endereco": fake.street_address(),
            "tipo": random.choice(["casa inteira", "quarto individual", "quarto compartilhado"]),
            "numero_quartos": random.randint(1, 5),
            "numero_banheiros": random.randint(1, 3),
            "preco_noite": random.randint(50, 1000) * 100,
            "min_noites": random.randint(1, 5),
            "max_noites": random.randint(5, 30),
            "max_hospedes": random.randint(1, 10),
            "taxa_limpeza": random.randint(10, 200) * 100,
            "horario_entrada": horario_entrada.strftime("%Y-%m-%d %H:%M:%S"),
            "horario_saida": (horario_entrada + random_timedelta()).strftime("%Y-%m-%d %H:%M:%S"),
            "datas_disponiveis": "ARRAY[" + ", ".join(["timestamp '"+random_timestamp(offset_days=i).strftime("%Y-%m-%d %H:%M:%S")+"'" for i in range(NUMBER_OF_REPETITIONS)]) + "]"
        }
        lista.append(dicionario)
    return lista

def generate_quarto(propriedades):
    return [
        {
            "id_propriedade": i + 1,
            "numero_camas": random.randint(1, 4),
            "tipo_cama": random.choice(["Casal", "Solteiro", "Queen", "King"]),
            "banheiro_privativo": fake.boolean()
        }
        for i in range(NUMBER_OF_REPETITIONS)
    ]

def generate_mensagem(usuarios):
    return [
        {
            "CPF_remetente": usuarios[0]["CPF"],
            "CPF_destinatario": usuarios[1]["CPF"],
            "texto": fake.text(max_nb_chars=200)
        }
        for _ in range(NUMBER_OF_REPETITIONS)
    ]

def generate_avaliacao(mensagens, propriedades):
    return [
        {
            "id_mensagem": i + 1,
            "id_propriedade": i + 1,
            "classificacao_limpeza": random.randint(0, 5),
            "classificacao_estrutura": random.randint(0, 5),
            "nota_comunicacao": random.randint(0, 10),
            "nota_localizacao": random.randint(0, 10),
            "nota_valor": random.randint(0, 10)
        }
        for i in range(NUMBER_OF_REPETITIONS)
    ]

def generate_reserva(usuarios, propriedades):
    return [
        {
            "CPF_locatario": usuarios[i % len(usuarios)]["CPF"],
            "CPF_locador": usuarios[i+1 % len(usuarios)]["CPF"],
            "id_propriedade": i + 1,
            "data_reserva": (horario_entrada := random_timestamp(offset_days=0, hour=0, minute= 0)).strftime("%Y-%m-%d %H:%M:%S"),
            "data_checkin": (horario_checkin := horario_entrada + random_timedelta()).strftime("%Y-%m-%d %H:%M:%S"),
            "data_checkout": (horario_checkin + random_timedelta()).strftime("%Y-%m-%d %H:%M:%S"),
            "numero_hospedes": random.randint(1, 5),
            "imposto": random.randint(10, 500) * 100,
            "preco_total_estadia": random.randint(100, 5000) * 100,
            "preco_total_imposto_limpeza": random.randint(50, 1000) * 100,
            "status": fake.boolean()
        }
        for i in range(NUMBER_OF_REPETITIONS)
    ]

def generate_ponto_de_interesse(localizacoes):
    return [
        {
            "id_localizacao": i + 1,
            "nome": fake.company()
        }
        for i in range(NUMBER_OF_REPETITIONS)
    ]

def write_to_sql_file(data, table_name, file):
    columns = ", ".join(data[0].keys())

    for row in data:
        value_list = []
        for key, v in row.items():
            if isinstance(v, str):
                if key != "datas_disponiveis":
                    escape_char = "'"
                    value_list.append(f"'{v.replace(escape_char, '')}'")
                else:
                    value_list.append(f"{v}")
            elif v is not None:
                value_list.append(f"{v}")
            else:
                value_list.append("NULL")
        values = ", ".join(value_list)
        
        file.write(f"INSERT INTO {table_name} ({columns}) VALUES ({values});\n")

def main():
    contas = generate_conta_bancaria()
    localizacoes = generate_localizacao()
    usuarios = generate_usuario(contas, localizacoes)
    propriedades = generate_propriedade()
    quartos = generate_quarto(propriedades)
    mensagens = generate_mensagem(usuarios)
    avaliacoes = generate_avaliacao(mensagens, propriedades)
    reservas = generate_reserva(usuarios, propriedades)
    pontos_interesse = generate_ponto_de_interesse(localizacoes)

    generated_path = "populate_database.sql"
    if os.path.exists(generated_path):
        os.remove(generated_path)

    with open(generated_path, "w", encoding="utf-8") as file:
        write_to_sql_file(contas, "ContaBancaria", file)
        write_to_sql_file(localizacoes, "Localizacao", file)
        write_to_sql_file(usuarios, "Usuario", file)
        write_to_sql_file(propriedades, "Propriedade", file)
        write_to_sql_file(quartos, "Quarto", file)
        write_to_sql_file(mensagens, "Mensagem", file)
        write_to_sql_file(avaliacoes, "Avaliacao", file)
        write_to_sql_file(reservas, "Reserva", file)
        write_to_sql_file(pontos_interesse, "PontoDeInteresse", file)
    
if __name__ == '__main__':
    main()
