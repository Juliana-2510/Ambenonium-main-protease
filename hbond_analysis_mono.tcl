# Arquivos de entrada
set psffile "step1_pdbreader_mono.pdb"  ;# Arquivo de estrutura (pode ser um PDB)
set trajfile "equil_filtered_mono_lig.dcd"  ;# Arquivo de trajetória

# Carregar os arquivos no VMD
mol new $psffile
mol addfile $trajfile waitfor all

# Criar arquivo de saída
set outfile [open "hbond_lig_protein_residues.dat" w]
puts $outfile "Frame\tResidue_Number\tResidue_Name\tDonor_Atom\tAcceptor_Atom\tDistance"

# Seleção da proteína e do ligante
set protein [atomselect top "protein"]
set ligand [atomselect top "resname LIG"]

# Parâmetros para detecção de ligações de hidrogênio
set cutoff_dist 3.5
set cutoff_angle 30

# Obter o número de frames na simulação
set num_frames [molinfo top get numframes]

# Loop sobre todos os frames
for {set i 0} {$i < $num_frames} {incr i} {
    # Atualizar seleção para o frame atual
    $protein frame $i
    $ligand frame $i

    # Medir ligações de hidrogênio entre proteína e ligante
    set hbonds [measure hbonds $cutoff_dist $cutoff_angle $protein $ligand]

    foreach bond $hbonds {
        set donor [lindex $bond 0]
        set acceptor [lindex $bond 1]

        # Se a seleção não for válida, continuar
        if {$donor == "" || $acceptor == ""} {
            continue
        }

        # Identificar os resíduos e átomos envolvidos
        set donor_resnum [lindex [$protein get residue] $donor]
        set donor_resname [lindex [$protein get resname] $donor]
        set donor_atom [lindex [$protein get name] $donor]
        set acceptor_atom [lindex [$ligand get name] $acceptor]

        # Verificar se os dados não são listas grandes
        if {[llength $donor_resnum] > 1 || [llength $donor_atom] > 1 || [llength $acceptor_atom] > 1} {
            continue
        }

        # Escrever no arquivo de saída
        puts $outfile "$i\t$donor_resnum\t$donor_resname\t$donor_atom\t$acceptor_atom\t1"
    }
}

# Fechar o arquivo de saída
close $outfile
puts "Análise concluída. Dados salvos em hbond_lig_protein_residues.dat"
