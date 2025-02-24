import pandas as pd
import matplotlib.pyplot as plt

def plot_residue_interactions(file_path):
    # Ler o arquivo e processar os dados
    data = []
    with open(file_path, "r") as file:
        lines = file.readlines()[1:]  # Ignorar o cabeçalho
        
        for line in lines:
            parts = line.strip().split("\t")
            parts = [p.strip() for p in parts if p.strip()]  # Remover espaços extras e entradas vazias
            if len(parts) >= 3:
                try:
                    frame = int(parts[0])
                    residue_number = int(parts[1])
                    residue_name = parts[2]
                    residue_label = f"{residue_name}{residue_number}"
                    data.append((frame, residue_label, residue_number))  # Adicionar número do resíduo separadamente
                except ValueError:
                    print(f"Linha ignorada por erro de conversão: {line.strip()}")
    
    # Criar DataFrame
    df = pd.DataFrame(data, columns=["Frame", "Residue", "Residue_Number"])
    
    # Ordenar resíduos numericamente
    df = df.sort_values(by="Residue_Number")
    df["Residue"] = pd.Categorical(df["Residue"], categories=df["Residue"].unique(), ordered=True)
    
    # Criar o gráfico
    plt.figure(figsize=(12, 6))
    plt.scatter(df["Frame"], df["Residue"], alpha=0.6, marker="o", color="black", s=50)
    plt.xlabel("Frame", fontsize=12)
    plt.ylabel("Amino Acid Residue", fontsize=12)
    plt.title("Ambenonium Interactions with Monomer Residues Over Time", fontsize=14)
    plt.xticks(rotation=45)
    plt.grid(True, linestyle="--", alpha=0.5)
    plt.show()

# Exemplo de uso
# Substitua pelo caminho do seu arquivo
file_path = "hbond_lig_protein_residues1.dat"
plot_residue_interactions(file_path)

