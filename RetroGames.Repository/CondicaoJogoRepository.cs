using System.Data.Common;
using RetroGames.Model.Model;

namespace RetroGames.Repository;

public class CondicaoJogoRepository : RepositoryBase, ICondicaoJogoRepository
{
    public CondicaoJogoRepository(RepositoryConfig config) : base(config)
    {
    }

    public async Task<List<CondicaoJogo>> ListarAsync()
    {
        await using var conexao = await AbrirConexaoAsync();
        const string sql = "SELECT co_condicao_jogo, ds_condicao_jogo FROM tb_condicao_jogo ORDER BY co_condicao_jogo ASC;";

        await using var comando = CriarComando(conexao, sql);
        await using var leitor = await comando.ExecuteReaderAsync();

        var condicoes = new List<CondicaoJogo>();
        while (await leitor.ReadAsync())
        {
            condicoes.Add(ConverterLinha(leitor));
        }

        return condicoes;
    }

    private static CondicaoJogo ConverterLinha(DbDataReader leitor)
    {
        return new CondicaoJogo
        {
            Id = leitor.GetInt32(leitor.GetOrdinal("co_condicao_jogo")),
            Descricao = leitor.GetString(leitor.GetOrdinal("ds_condicao_jogo"))
        };
    }
}
