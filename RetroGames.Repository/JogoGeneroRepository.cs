using System.Data.Common;
using RetroGames.Model.Model;

namespace RetroGames.Repository;

public class JogoGeneroRepository : RepositoryBase, IJogoGeneroRepository
{
    public JogoGeneroRepository(RepositoryConfig config) : base(config)
    {
    }

    public async Task<List<JogoGenero>> ListarTodosAsync()
    {
        await using var conexao = await AbrirConexaoAsync();
        const string sql = "SELECT co_jogo, co_genero FROM tb_jogo_genero;";

        await using var comando = CriarComando(conexao, sql);
        await using var leitor = await comando.ExecuteReaderAsync();

        var vinculos = new List<JogoGenero>();
        while (await leitor.ReadAsync())
        {
            vinculos.Add(ConverterLinha(leitor));
        }

        return vinculos;
    }

    public async Task<List<JogoGenero>> ListarPorJogosAsync(List<int> idsJogos)
    {
        if (idsJogos == null || idsJogos.Count == 0)
        {
            return new List<JogoGenero>();
        }

        await using var conexao = await AbrirConexaoAsync();
        var paramNames = new List<string>();
        for (var i = 0; i < idsJogos.Count; i++)
        {
            paramNames.Add($"@idJogo{i}");
        }

        var sql = $"SELECT co_jogo, co_genero FROM tb_jogo_genero WHERE co_jogo IN ({string.Join(", ", paramNames)});";
        await using var comando = CriarComando(conexao, sql);

        for (var i = 0; i < idsJogos.Count; i++)
        {
            AdicionarParametro(comando, $"@idJogo{i}", idsJogos[i]);
        }

        await using var leitor = await comando.ExecuteReaderAsync();
        var vinculos = new List<JogoGenero>();
        while (await leitor.ReadAsync())
        {
            vinculos.Add(ConverterLinha(leitor));
        }

        return vinculos;
    }

    public async Task InserirAsync(int idJogo, List<int> idsGeneros)
    {
        if (idsGeneros == null || idsGeneros.Count == 0)
        {
            return;
        }

        await using var conexao = await AbrirConexaoAsync();
        foreach (var idGenero in idsGeneros)
        {
            const string sql = "INSERT INTO tb_jogo_genero (co_jogo, co_genero) VALUES (@idJogo, @idGenero);";
            await using var comando = CriarComando(conexao, sql);
            AdicionarParametro(comando, "@idJogo", idJogo);
            AdicionarParametro(comando, "@idGenero", idGenero);
            await comando.ExecuteNonQueryAsync();
        }
    }

    public async Task RemoverPorJogoAsync(int idJogo)
    {
        await using var conexao = await AbrirConexaoAsync();
        const string sql = "DELETE FROM tb_jogo_genero WHERE co_jogo = @idJogo;";

        await using var comando = CriarComando(conexao, sql);
        AdicionarParametro(comando, "@idJogo", idJogo);
        await comando.ExecuteNonQueryAsync();
    }

    private static JogoGenero ConverterLinha(DbDataReader leitor)
    {
        return new JogoGenero
        {
            IdJogo = leitor.GetInt32(leitor.GetOrdinal("co_jogo")),
            IdGenero = leitor.GetInt32(leitor.GetOrdinal("co_genero"))
        };
    }
}
