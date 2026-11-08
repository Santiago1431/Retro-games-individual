using System.Data.Common;
using RetroGames.Model.Model;

namespace RetroGames.Repository;

public class GeneroRepository : RepositoryBase, IGeneroRepository
{
    public GeneroRepository(RepositoryConfig config) : base(config)
    {
    }

    public async Task<List<Genero>> ListarAsync()
    {
        await using var conexao = await AbrirConexaoAsync();
        const string sql = "SELECT co_seq_genero, no_genero FROM tb_genero ORDER BY no_genero ASC;";

        await using var comando = CriarComando(conexao, sql);
        await using var leitor = await comando.ExecuteReaderAsync();

        var generos = new List<Genero>();
        while (await leitor.ReadAsync())
        {
            generos.Add(ConverterLinha(leitor));
        }

        return generos;
    }

    private static Genero ConverterLinha(DbDataReader leitor)
    {
        return new Genero
        {
            Id = leitor.GetInt32(leitor.GetOrdinal("co_seq_genero")),
            Nome = leitor.GetString(leitor.GetOrdinal("no_genero"))
        };
    }
}
